#===============================================================================
#===============================================================================
# Library.......................................................................
library(here)
library(corrplot)
library(pals)
library(scico)
#===============================================================================
setwd(here())
#===============================================================================
#===============================================================================
# Non Squared Matrix Visualization..............................................
data_t= read.csv(here("Data", "heritabilityEffect_ThreeGradients.csv"))
grad = as.matrix(data_t[data_t$Stat == "h2 - Var", 5:7])
rownames(grad) = c(1:7)
pValue = as.matrix(data_t[data_t$Stat == "Prob. > |t|", 5:7])
rownames(pValue) = c(1:7)

grpEfct = corrplot(grad, 
                   is.corr = FALSE, col.lim = c(0, 0.28), 
                   p.mat = pValue,
                   sig.level = (0.05/7), insig='blank',
                   method = 'color', # 'circle' | 'color'
                   col = coolwarm(n=400)[200:400], # rev(viridis_pal(option="magma")(200)), #scico(200, palette = 'vanimo'), # coolwarm(n=400)[200:400], # scico(200, palette = 'buda'),
                   tl.pos = 'n', 
                   cl.pos = 'n', # n pour pas afficher la legende, r pour la mettre a droite
                   addCoef.col = 'white',
                   addgrid.col = 'white')

# ggsave(file="h2Effect_MatrixVis.svg",
#        plot=grpEfct,
#        width = 2, height = 5.8,
#        units = "in",
#        dpi = 1200)