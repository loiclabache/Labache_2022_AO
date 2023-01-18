#===============================================================================
#===============================================================================
# Library.......................................................................
library(here)
library(corrplot)
library(pals)
#===============================================================================
setwd(here())
#===============================================================================
#===============================================================================
# Non Squared Matrix Visualization..............................................
data_t= read.csv(here("Data", "groupEffect_ThreeGradients.csv"))
grad = as.matrix(data_t[data_t$Stat == "t ratio", 5:7])
rownames(grad) = c(1:7)
pValue = as.matrix(data_t[data_t$Stat == "Prob. > |t|", 5:7])
rownames(pValue) = c(1:7)

grpEfct = corrplot(grad, 
                   is.corr = FALSE, col.lim = c(-12, 12), 
                   p.mat = pValue, 
                   sig.level = (0.05/7), insig='blank',
                   method = 'color', # 'circle' | 'color'
                   col = coolwarm(n=200),
                   tl.pos = 'n', cl.pos = 'r', 
                   addCoef.col = 'black',
                   # addCoef.col = 'black',
                   addgrid.col = 'white')

# ggsave(file="groupEffect_MatrixVis.svg", 
#        plot=fig_Grad_Yeo_tertiaire,
#        width = 2, height = 5.8,
#        units = "in",
#        dpi = 1200)