# # ID Amazon
# USERNAME: *******
# ACCESS KEY ID: **************
# SECRET ACCESS KEY: *********************
#-------------------------------------------------------------------------------
# # Packages
library(here)
library(neurohcp)
library(reshape2)
library(dplyr)
library(RNifti)
library(oro.nifti)
#-------------------------------------------------------------------------------
# # Work Directory
setwd(here())
#-------------------------------------------------------------------------------
# # Connection to Amazon Server
set_aws_api_key(access_key = "ACCESS_KEY_ID", 
                secret_key = "SECRET_ACCESS_KEY")
if (have_aws_key()) {
  neurohcp::bucketlist()
}
#-------------------------------------------------------------------------------
# # Participants List
ids_HCSP = as_tibble(read.csv(here("Data", "infos_995participants.csv"))) %>%
  select(Subject)
colnames(ids_HCSP)[1] = "id"
ids_HCSP$id = as.character(ids_HCSP$id)
#-------------------------------------------------------------------------------
# # Atlas
aicha = readNIfTI(here("Atlas", "AICHA", "AICHA.nii"))
nb_ROI = length(table(aicha))-1 # minus one because we delet the zero that is not an ROI
# Selected regions informations
regionNumber = read.csv(here("Atlas", "SENSAAS", "Volumetric", "SENTcore_bothHemi.csv"))
aicha_matrix = matrix(aicha, ncol = 1, byrow = FALSE)
#-------------------------------------------------------------------------------
# What do you want?
file_hcp = c("rfMRI_REST1_LR_hp2000_clean.nii.gz",
             "rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii")
i=1 # do the choice among file_hcp
if (!dir.exists(here("rest_TimeSerie_Volumes"))) {dir.create(here("rest_TimeSerie_Volumes"))}
for (j in 1:995){ # from the 1st participant to the 995th one
  print(paste("======== Participant number: ", as.character(ids_HCSP[j, 1]), sep=""))
  # # Download & Extract Information Data
  start_time <- Sys.time()
  # Files are downloaded in a folder called "rest_TimeSerie_Volumes"
  tmp = download_hcp_file(path_to_file = paste("HCP_1200/",
                                               ids_HCSP[j, 1],
                                               "/MNINonLinear/Results/rfMRI_REST1_LR/",
                                               file_hcp[i], 
                                               sep=""), 
                          verbose = TRUE,
                          destfile = paste("rest_TimeSerie_Volumes/",
                                           ids_HCSP[j, 1],"_",
                                           file_hcp[i],sep=""))
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("File download time: ", round(temps, 2), " ", units(temps), sep=""))
  # Read the data again :
  start_time <- Sys.time()
  tmp = RNifti::readNifti(paste("rest_TimeSerie_Volumes/",
                                ids_HCSP[j, 1],"_",
                                file_hcp[i],sep=""), internal=FALSE)
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("File reading time: ", round(temps, 2), " ", units(temps), sep=""))
  numberOfTimePoint = dim(tmp)[4]
  # Delet the useless file
  unlink(paste("rest_TimeSerie_Volumes/",
               ids_HCSP[j, 1],"_",
               file_hcp[i],sep=""))
  # Melt the data
  start_time <- Sys.time()
  tmp_matrix = matrix(tmp, ncol = dim(tmp)[4], byrow = FALSE)
  tmp = NULL
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("File reshaping time: ", round(temps, 2), " ", units(temps), sep=""))
  # Compute the mean
  start_time <- Sys.time()
  ts_ROI = sapply(regionNumber$color,
                  function(r){
                    index_ROI = which(aicha_matrix[,1] == r)
                    colMeans(tmp_matrix[index_ROI,])
                  }, simplify = "array")
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("Time of the average time course calculation: ", round(temps, 2), " ", units(temps), sep=""))
  write.csv(ts_ROI,
            file = paste("rest_TimeSerie_Volumes/",
                         ids_HCSP[j, 1],
                         "_SENTcore_",
                         gsub('nii.gz','csv',file_hcp[i]), 
                         sep=""))
}
print("It is over!")



