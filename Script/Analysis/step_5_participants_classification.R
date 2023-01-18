#===============================================================================
# Library.......................................................................
if(!require(here)){
  install.packages("here")
  library(here)
}
if(!require(dendextend)){
  install.packages("dendextend")
  library(dendextend)
}
if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}
if(!require(reshape2)){
  install.packages("reshape2")
  library(reshape2)
}
if(!require(readxl)){
  install.packages("readxl")
  library(readxl)
}
#===============================================================================
# Workplace......................................................................
setwd(here())
#===============================================================================
# Read the data.................................................................
dataP <- read_excel(here("Data", "995participants_language_metrics_HCP.xlsx"))
#===============================================================================
# Find the clusters..............................................................
h <- hclust(dist(scale(dataP[,c(4,7,10,11,12)], center=T, scale=T),
                 method = "euclidean"),
            method = "ward.D2")
nb_clsuter = 3
table(cutree(h, nb_clsuter))
#...............................................................................
# Plot the dendogram............................................................
h_dend = as.dendrogram(h) %>%
  color_branches(k = nb_clsuter)
plot(h_dend)
