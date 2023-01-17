# # ID Amazon
# USERNAME: *******
# ACCESS KEY ID: **************
# SECRET ACCESS KEY: *********************
#-------------------------------------------------------------------------------
# # Package
library(here)
library(neurohcp)
library(reshape2)
library(dplyr)
library(RNifti)
library(oro.nifti)
library(psych)
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
nb_ROI = length(table(aicha))-1 # minus one because we delete the zero that is not an ROI
aicha_matrix = matrix(aicha, ncol = 1, byrow = FALSE)
#-------------------------------------------------------------------------------
# # Compute correlation matrix for each participants for a given atlas:
file_hcp = c("rfMRI_REST1_LR_hp2000_clean.nii.gz",
             "rfMRI_REST2_LR_hp2000_clean.nii.gz",
             "rfMRI_REST1_RL_hp2000_clean.nii.gz",
             "rfMRI_REST2_RL_hp2000_clean.nii.gz")
if (!dir.exists(here("correlationMatrix_Individual"))) {dir.create(here("correlationMatrix_Individual"))}
for (j in from_v:to_v){
  print(paste("======== Participant id: ", j, sep=""))
  print(paste("======== Participant number: ", as.character(ids_HCSP[j, 1]), sep=""))
  #.............................................................................
  # # Download & Extract Information Data
  start_time <- Sys.time()
  tmp1LR = RNifti::readNifti(download_hcp_file(path_to_file = paste("HCP_1200/",
                                                                    ids_HCSP[j, 1],
                                                                    "/MNINonLinear/Results/rfMRI_REST1_LR/",
                                                                    file_hcp[1], 
                                                                    sep=""), 
                                               verbose = TRUE), internal=FALSE)
  tmp2LR = RNifti::readNifti(download_hcp_file(path_to_file = paste("HCP_1200/",
                                                                    ids_HCSP[j, 1],
                                                                    "/MNINonLinear/Results/rfMRI_REST2_LR/",
                                                                    file_hcp[2], 
                                                                    sep=""), 
                                               verbose = TRUE), internal=FALSE)
  tmp1RL = RNifti::readNifti(download_hcp_file(path_to_file = paste("HCP_1200/",
                                                                    ids_HCSP[j, 1],
                                                                    "/MNINonLinear/Results/rfMRI_REST1_RL/",
                                                                    file_hcp[3], 
                                                                    sep=""), 
                                               verbose = TRUE), internal=FALSE)
  tmp2RL = RNifti::readNifti(download_hcp_file(path_to_file = paste("HCP_1200/",
                                                                    ids_HCSP[j, 1],
                                                                    "/MNINonLinear/Results/rfMRI_REST2_RL/",
                                                                    file_hcp[4], 
                                                                    sep=""), 
                                               verbose = TRUE), internal=FALSE)
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("File download and reading time: ",round(temps, 2), " ", units(temps), sep=""))
  #.............................................................................
  # Melt the data
  start_time <- Sys.time()
  tmp_matrix_1LR = matrix(tmp1LR, 
                          ncol = dim(tmp1LR)[4], 
                          byrow = FALSE)
  tmp_matrix_2LR = matrix(tmp2LR, 
                          ncol = dim(tmp2LR)[4], 
                          byrow = FALSE)
  tmp_matrix_1RL = matrix(tmp1RL, 
                          ncol = dim(tmp1RL)[4], 
                          byrow = FALSE)
  tmp_matrix_2RL = matrix(tmp2RL, 
                          ncol = dim(tmp2RL)[4], 
                          byrow = FALSE)
  tmp1LR = tmp2LR = tmp1RL = tmp2RL = NULL
  gc()
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("File reshaping time: ",
              round(temps, 2), " ", units(temps), sep=""))
  #.............................................................................
  # Compute the mean time serie by ROI
  start_time <- Sys.time()
  ts_ROI_1LR = sapply(1:nb_ROI,
                      function(r){
                        index_ROI = which(aicha_matrix[,1] == r)
                        colMeans(tmp_matrix_1LR[index_ROI,])
                      }, simplify = "array")
  ts_ROI_2LR = sapply(1:nb_ROI,
                      function(r){
                        index_ROI = which(aicha_matrix[,1] == r)
                        colMeans(tmp_matrix_2LR[index_ROI,])
                      }, simplify = "array")
  ts_ROI_1RL = sapply(1:nb_ROI,
                      function(r){
                        index_ROI = which(aicha_matrix[,1] == r)
                        colMeans(tmp_matrix_1RL[index_ROI,])
                      }, simplify = "array")
  ts_ROI_2RL = sapply(1:nb_ROI,
                      function(r){
                        index_ROI = which(aicha_matrix[,1] == r)
                        colMeans(tmp_matrix_2RL[index_ROI,])
                      }, simplify = "array")
  end_time <- Sys.time()
  temps = end_time - start_time
  print(paste("Time of the average time course calculation: ", round(temps, 2), " ", units(temps), sep=""))
  tmp_matrix_1LR = tmp_matrix_2LR = tmp_matrix_1RL= tmp_matrix_2RL = NULL
  gc()
  #.............................................................................
  # Compute correlation matrix
  c_1LR = cor(ts_ROI_1LR)
  c_2LR = cor(ts_ROI_2LR)
  c_1RL = cor(ts_ROI_1RL)
  c_2RL = cor(ts_ROI_2RL)
  ts_ROI_1LR = ts_ROI_2LR = ts_ROI_1RL= ts_ROI_2RL = NULL
  gc()
  #.............................................................................
  # Compute the average matrix of the 4 different rfMRI scans...................
  concat_cor = fisherz2r(((fisherz(c_1LR) + fisherz(c_2LR) +
                             fisherz(c_1RL) + fisherz(c_2RL))/4))
  #.............................................................................
  # reorder the matrix: LH next RH
  concat_cor = concat_cor[c(seq(from=1,to=dim(concat_cor)[1], by=2),
                            seq(from=0,to=dim(concat_cor)[1], by=2)[-1]),
                          c(seq(from=1,to=dim(concat_cor)[1], by=2),
                            seq(from=0,to=dim(concat_cor)[1], by=2)[-1])]
  print(concat_cor[1:10,1:10])
  #.............................................................................
  write.csv(concat_cor,
            file = paste("correlationMatrix_Individual/",
                         ids_HCSP[j, 1],
                         "_correlationMatrix_AICHA_4scansAverage.csv", 
                         sep=""))
  
}
print("It is over!")







