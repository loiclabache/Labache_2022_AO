#===============================================================================
#-------------------------------------------------------------------------------
# # Package.....................................................................
library(plotly)
library(readxl)
library(pals)
library(corrplot)
library(here)
#===============================================================================
#-------------------------------------------------------------------------------
# # Work Directory..............................................................
setwd(here())
#===============================================================================
#-------------------------------------------------------------------------------
# # # Gradients Visualization..//...............................................
gradients_files = list.files(here(), pattern=".csv")
listGraph = vector("list", length(gradients_files))
for (i in 1: length(gradients_files)){
  print(i)
  sujet_grad = read.csv(paste(here(),
                              gradients_files[i], sep=""),
                        header=F)
  fig <- plot_ly(sujet_grad,
                 x = ~V1, y = ~V2, z = ~V3,
                 marker = list(color = ~V1,
                               showscale = TRUE)) %>%
    add_markers() %>%
    layout(scene = list(xaxis = list(title = 'G1'),
                        yaxis = list(title = 'G2'),
                        zaxis = list(title = 'G3')))
  listGraph[[i]] = fig
}
listGraph[[1]]

#===============================================================================
#-------------------------------------------------------------------------------
# # Creation du fichier de travail..............................................
gradients_all = list.files(here(), 
                           pattern=".csv")
firstGrad = matrix(0, nrow = 384, ncol = (length(gradients_all)+2))
colnames(firstGrad) = c("Region_Number", "Side",
                        gsub(".csv","",gradients_all))
firstGrad[,1] = c(c(1:(dim(firstGrad)[1]/2)),
                  c(1:(dim(firstGrad)[1]/2)))
firstGrad[1:4,1:5]

for (i in 3:dim(firstGrad)[2]){
  print(i-2)
  firstGrad[,i] = as.numeric(read.csv(paste(here(),
                                            gradients_all[i-2], sep=""),
                                      header=F)[,2])
  
}
firstGrad = as.data.frame(firstGrad)
firstGrad[,2] = c(rep('L',(dim(firstGrad)[1]/2)),
                  rep('R',(dim(firstGrad)[1]/2)))
firstGrad[190:195,1:5]
write.table(firstGrad,
            file="995participants_Gradients.txt", 
            row.names=FALSE,
            col.names=TRUE,
            sep="\t")
