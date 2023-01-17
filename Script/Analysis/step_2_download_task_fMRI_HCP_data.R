# # ID Amazon
# USERNAME: *******
# ACCESS KEY ID: **************
# SECRET ACCESS KEY: *********************
#-------------------------------------------------------------------------------
# # Packages
library(here)
library(RNifti)
library(oro.nifti)
library(dplyr)
library(neurohcp)
library(gifti)
#-------------------------------------------------------------------------------
# # Work Directory
setwd(here())
#-------------------------------------------------------------------------------
# # Participants List
ids_HCSP = as_tibble(read.csv(here("Data", "infos_995participants.csv"))) %>%
  select(Subject)
colnames(ids_HCSP)[1] = "id"
ids_HCSP$id = as.character(ids_HCSP$id)
#===============================================================================
# ROI creation..................................................................
# # Atlas
aicha = readNIfTI(here("Atlas", "AICHA", "AICHA.nii"))
# Selected regions
regionNumber = read.csv(here("Atlas", "SENSAAS", "Volumetric", "SENTcore_bothHemi.csv"))
if (!dir.exists(here("tfMRI_LANGUAGE", "SENTcore_SENSAAS_atlas"))) {dir.create(here("tfMRI_LANGUAGE", "SENTcore_SENSAAS_atlas"))}
savePath="/tfMRI_LANGUAGE/SENTcore_SENSAAS_atlas/" 
resNetwork=aicha
resNetwork[resNetwork != 0] = 0
for (i in 1:length(regionNumber$color)){ # Hub level: c(5,6,25:28) | SentCore level: 1:length(regionNumber$color)
  print(i)
  tmp = aicha
  tmp[tmp != regionNumber$color[i]] = 0
  tmp[tmp!=0] = 1
  resNetwork = resNetwork + tmp
  # writeNifti(tmp, 
  #            file=paste(getwd(), savePath, regionNumber$nom_s[i],
  #                       ".nii.gz", sep=""))
}
writeNifti(resNetwork, 
           file=paste(getwd(), savePath, 
                      "binarySentCore_volume.nii.gz", sep=""))
#===============================================================================
# Download activation & brain template..........................................
# Connection to Amazon Server
set_aws_api_key(access_key = "ACCESS_KEY_ID", 
                secret_key = "SECRET_ACCESS_KEY")
if (have_aws_key()) {
  neurohcp::bucketlist()
}
# Download
if (!dir.exists(here("tfMRI_LANGUAGE", "Individual_template"))) {dir.create(here("tfMRI_LANGUAGE", "Individual_template"))}
if (!dir.exists(here("tfMRI_LANGUAGE", "Activation"))) {dir.create(here("tfMRI_LANGUAGE", "Activation"))}
for (j in 1:dim(ids_HCSP)[1]){ #j=41
  print(paste("======== Participant number: ", j, sep=""))
  start_time <- Sys.time()
  download_hcp_file(path_to_file = paste("HCP_1200/",
                                         ids_HCSP[j, 1],
                                         "/MNINonLinear/fsaverage_LR32k/", 
                                         ids_HCSP[j, 1], ".L.midthickness.32k_fs_LR.surf.gii",
                                         sep=""), 
                    verbose = TRUE,
                    error = FALSE,
                    destfile = paste("tfMRI_LANGUAGE/Individual_template/",
                                     ids_HCSP[j, 1], ".L.midthickness.32k_fs_LR.surf.gii",
                                     sep=""))
  download_hcp_file(path_to_file = paste("HCP_1200/",
                                         ids_HCSP[j, 1],
                                         "/MNINonLinear/fsaverage_LR32k/", 
                                         ids_HCSP[j, 1], ".R.midthickness.32k_fs_LR.surf.gii",
                                         sep=""), 
                    verbose = TRUE,
                    error = FALSE,
                    destfile = paste("tfMRI_LANGUAGE/Individual_template/",
                                     ids_HCSP[j, 1], ".R.midthickness.32k_fs_LR.surf.gii",
                                     sep=""))
  download_hcp_file(path_to_file = paste("HCP_1200/",
                                         ids_HCSP[j, 1],
                                         "/MNINonLinear/Results/tfMRI_LANGUAGE/tfMRI_LANGUAGE_hp200_s4_level2.feat/", 
                                         ids_HCSP[j, 1], "_tfMRI_LANGUAGE_level2_hp200_s4.dscalar.nii",
                                         sep=""), 
                    verbose = TRUE,
                    destfile =paste("tfMRI_LANGUAGE/Activation/",
                                    ids_HCSP[j, 1], "_tfMRI_LANGUAGE_level2_hp200_s4.dscalar.nii",
                                    sep=""))
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("Download time: ", round(temps, 2), " ", units(temps), sep=""))
}




