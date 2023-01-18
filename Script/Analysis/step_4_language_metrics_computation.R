#===============================================================================
# Library.......................................................................
if(!require(here)){
  install.packages("here")
  library(here)
}
if(!require(oro.nifti)){
  install.packages("oro.nifti")
  library(oro.nifti)
}
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}
if(!require(neurohcp)){
  install.packages("neurohcp")
  library(neurohcp)
}
if(!require(gifti)){
  install.packages("gifti")
  library(gifti)
}
if(!require(psych)){
  install.packages("psych")
  library(psych)
}
# Workplace......................................................................
setwd(here())
#===============================================================================
# Participants' List............................................................
ids_HCSP = as_tibble(read.csv(here("Data", "infos_995participants.csv"))) %>%
  select(Subject)
colnames(ids_HCSP)[1] = "id"
ids_HCSP$id = as.character(ids_HCSP$id)
#===============================================================================
# Results Matrix................................................................
target_variables = c("STORYminusMath_SentCore_L", "STORYminusMath_SentCore_R",
                     "STORYminusMath_SentCore_Asym", "STORYminusMath_Hubs_L", 
                     "STORYminusMath_Hubs_R", "STORYminusMath_Hubs_Asym",
                     "DC_L", "DC_R", "DC_Asym", "DC_Sum", "r_interHemi")
results = matrix(NA, nrow = dim(ids_HCSP)[1], ncol = length(target_variables))
rownames(results) = ids_HCSP$id
colnames(results) = target_variables
#===============================================================================
# Mean activity in a network....................................................
contrast=setNames(c(1:6), c("math", "story","math-story", "story-math", 
                            "negMath", "negStory"))
for (p in 1:dim(ids_HCSP)[1]){
  print(paste(p, " / ", dim(ids_HCSP)[1], sep=""))
  #.............................................................................
  # Read activation map.........................................................
  # LH 
  activation_L = readgii(paste(here("tfMRI_LANGUAGE", "Activation_by_hemisphere"), "/",
                               ids_HCSP[p, 1], "_CORTEX_LEFT_tfMRI_LANGUAGE_level2_hp200_s4.shape.gii",
                               sep=""))$data[[contrast[4]]]
  # RH
  activation_R = readgii(paste(here("tfMRI_LANGUAGE", "Activation_by_hemisphere"), "/",
                               ids_HCSP[p, 1], "_CORTEX_RIGHT_tfMRI_LANGUAGE_level2_hp200_s4.shape.gii",
                               sep=""))$data[[contrast[4]]]
  #.............................................................................
  # Activation at the Network level.............................................
  # LH
  sentCore_L = readgii(paste(here("Atlas", "SENSAAS", "Area"), "/",
                             # ids_HCSP[p, 1], 
                             "S1200_binarySentCore_L_surface.shape.gii",
                             sep=""))$data[[1]]
  meanActivation_L = activation_L[sentCore_L[,1]==1]
  results[p, 1] = sum(meanActivation_L, na.rm = TRUE)/table(sentCore_L[,1]==1)[2]
  # RH 
  sentCore_R = readgii(paste(here("Atlas", "SENSAAS", "Area"), "/",
                             # ids_HCSP[p, 1], 
                             "S1200_binarySentCore_R_surface.shape.gii",
                             sep=""))$data[[1]]
  meanActivation_R = activation_R[sentCore_R[,1]==1]
  results[p, 2] = sum(meanActivation_R, na.rm = TRUE)/table(sentCore_R[,1]==1)[2]
  # Asym (LH-RH)
  results[p, 3] = results[p, 1] - results[p, 2]
  #.............................................................................
  # Activation at Hub level.....................................................
  # LH
  hub_L = readgii(paste(here("Atlas", "SENSAAS", "Area"), "/",
                             # ids_HCSP[p, 1], 
                             "S1200_binaryHubsSentCore_L_surface.shape.gii",
                             sep=""))$data[[1]]
  meanActivation_hub_L = activation_L[hub_L[,1]==1]
  results[p, 4] = sum(meanActivation_hub_L, na.rm = TRUE)/table(hub_L[,1]==1)[2]
  # RH
  hub_R = readgii(paste(here("Atlas", "SENSAAS", "Area"), "/",
                        # ids_HCSP[p, 1], 
                        "S1200_binaryHubsSentCore_R_surface.shape.gii",
                        sep=""))$data[[1]]
  meanActivation_hub_R = activation_R[hub_R[,1]==1]
  results[p, 5] = sum(meanActivation_hub_R, na.rm = TRUE)/table(hub_R[,1]==1)[2]
  # Asym (LH-RH)
  results[p, 6] = results[p, 4] - results[p, 5]
  #.............................................................................
  #.............................................................................
  # read rfMRI data time-series.................................................
  tmp1 = read.csv(paste(here("rest_TimeSerie_Volumes"), "/",
                        ids_HCSP[p, 1], 
                        "_SENTcore_rfMRI_REST1_LR_hp2000_clean.csv",
                        sep=""))[,-1]
  tmp2 = read.csv(paste(here("rest_TimeSerie_Volumes"), "/",
                        ids_HCSP[p, 1], 
                        "_SENTcore_rfMRI_REST1_RL_hp2000_clean.csv",
                        sep=""))[,-1]
  tmp3 = read.csv(paste(here("rest_TimeSerie_Volumes"), "/",
                        ids_HCSP[p, 1], 
                        "_SENTcore_rfMRI_REST2_LR_hp2000_clean.csv",
                        sep=""))[,-1]
  tmp4 = read.csv(paste(here("rest_TimeSerie_Volumes"), "/",
                        ids_HCSP[p, 1], 
                        "_SENTcore_rfMRI_REST2_RL_hp2000_clean.csv",
                        sep=""))[,-1]
  #.............................................................................
  # Compute the average matrix of the 4 different rfMRI scans...................
  concat_ts = fisherz2r(((fisherz(cor(tmp1)) + fisherz(cor(tmp2)) +
                            fisherz(cor(tmp3)) + fisherz(cor(tmp4)))/4))
  #.............................................................................
  # reorder the matrix: LH next RH
  concat_ts = concat_ts[c(seq(from=1,to=dim(concat_ts)[1], by=2),
                          seq(from=0,to=dim(concat_ts)[1], by=2)[-1]),
                        c(seq(from=1,to=dim(concat_ts)[1], by=2),
                          seq(from=0,to=dim(concat_ts)[1], by=2)[-1])]
  #.............................................................................
  # compute centrality degree...................................................
  # LH
  mat_L = concat_ts[c(1:(dim(concat_ts)[1]/2)), 
                    c(1:(dim(concat_ts)[1]/2))]
  diag(mat_L) = 0
  results[p, 7] = mean(colSums(mat_L))
  # RH
  mat_R = concat_ts[c(((dim(concat_ts)[1]/2)+1):dim(concat_ts)[1]), 
                    c(((dim(concat_ts)[1]/2)+1):dim(concat_ts)[1])]
  diag(mat_R) = 0
  results[p, 8] = mean(colSums(mat_R))
  # Asym (LH-RH)
  results[p, 9] = results[p, 7] - results[p, 8]
  # Sum (LH+RH)
  results[p, 10] = results[p, 7] + results[p, 8]
  #.............................................................................
  # compute homotopic inter-hemispheric correlation.............................
  results[p, 11] = fisherz2r(mean(fisherz(diag(concat_ts[c(1:(dim(concat_ts)[1]/2)), 
                                                         c(((dim(concat_ts)[1]/2)+1):dim(concat_ts)[1])]))))
}

hist(results[,1])
hist(results[,2])
hist(results[,3])
summary(results[,1])
summary(results[,2])
summary(results[,3])

# write.csv(results, file="_results_HCP.csv")
