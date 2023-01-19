library(tidyverse)
library(here)
library(gifti)
library(solarius)

#...............................................................................
# UPDATE - February 2022........................................................
# Mac part:
# download from: https://www.nitrc.org/projects/se_linux/
# sudo ./install_solar /usr/local/solar/9.0.0 /usr/local/bin solar
# R part: 
# library(devtools)
# install_github("ugcd/solarius")
#...............................................................................

#...............................................................................
# Functions.....................................................................
calc_net_heritability = function(df, trait_list, covars){

  covar_formula = paste0(covars, collapse=' + ')
  
  h2_df = NULL
  for (trait in trait_list){
    write(trait, '')
    gradientNB = strsplit(trait, '\\.')[[1]][2]
    side = strsplit(trait, '\\.')[[1]][4]
    type = strsplit(trait, '\\.')[[1]][3]
    network = strsplit(trait, '\\.')[[1]][1]
    
    df[trait] = scale(df[trait])
    formula = as.formula(paste0(trait, ' ~ ', covar_formula))
    # rhog = solarPolygenic(formula, df)
    rhog = solarPolygenic(formula, df, covtest = TRUE)
    
    out_row = rhog$vcf[1,]
    
    out_row$gradientNB = gradientNB
    out_row$side = side
    out_row$type = type
    out_row$network = network
    
    print(out_row)
    
    covLong <- pivot_longer(rhog$cf,
                            cols=2:5, 
                            names_to = "statistic", 
                            values_to = "value")
    covLong$statistic_value = paste(covLong$covariate, covLong$statistic, 
                                    sep=" - ")
    covWide = as.data.frame(pivot_wider(covLong[,-c(1:2)], 
                                        names_from = statistic_value,
                                        values_from = value))
    resAll = cbind(out_row, covWide)
    h2_df = rbind(h2_df, resAll)
  }
  return(h2_df)
}
calc_net_coheritability = function(df, trait_list, covars){
  
  covar_formula = paste0(covars, collapse=' + ')
  
  h2_df = NULL
  for (trait in trait_list){
    write(trait, '')
    gradientNB = strsplit(trait, '\\.')[[1]][2]
    side = strsplit(trait, '\\.')[[1]][4]
    type = strsplit(trait, '\\.')[[1]][3]
    network = strsplit(trait, '\\.')[[1]][1]
    
    df[trait] = scale(df[trait])
    formula = as.formula(paste0('Cluster_MMHC + ', trait, ' ~ ', 
                                covar_formula))
    # rhog = solarPolygenic(formula, df)
    rhog = solarPolygenic(formula, df, 
                          polygenic.options = "-testrhoe -testrhog")
    
    out_row = rhog$vcf[5:6,]
    
    out_row$gradientNB = c(gradientNB, gradientNB)
    out_row$side = c(side, side)
    out_row$type = c(type, type)
    out_row$network = c(network, network)
    
    print(out_row)
    
    h2_df = rbind(h2_df, out_row)
  }
  return(h2_df)
}
#...............................................................................
#...............................................................................

setwd(here())

#...............................................................................
#...............................................................................
# Data..........................................................................
hcp_df = read.csv(here("Data", "hcpNetwork_for_solar.csv"))
hcp_df$age2 = hcp_df$Age_in_Yrs^2
hcp_df$age2_scale = as.numeric(scale(hcp_df$age2))
hcp_df$FS_IntraCranial_Vol_scale = as.numeric(scale(hcp_df$FS_InterCranial_Vol))
hcp_df$Age_in_Yrs_scale = as.numeric(scale(hcp_df$Age_in_Yrs))
# only missing a single BMI value, so plug in median
hcp_df$BMI[is.na(hcp_df$BMI)] = median(hcp_df$BMI, na.rm=T)
hcp_df$Ethnicity_bin = as.numeric(grepl('Not', hcp_df$Ethnicity))
hcp_df$sex_bin = ifelse(hcp_df$sex == 'M', 1, 0)
hcp_df$age_sex = hcp_df$Age_in_Yrs * hcp_df$sex_bin
hcp_df$age2_sex = hcp_df$age2 * hcp_df$sex_bin
hcp_df$grp_bin = ifelse(hcp_df$Cluster_MMHC_binaireCategory == 'Atypical', 1, 0)
#...............................................................................
#...............................................................................

#...............................................................................
#...............................................................................
# Heritability of Language Lateralization:
# - With PM as covariate
hcp_df$PM_bin = ifelse(hcp_df$PM_strict_30ES == 'D', 1, 0)
covars_tri = c('PM_bin',
               'Age_in_Yrs_scale',
               'sex',
               'age2_scale',
               'FS_IntraCranial_Vol_scale',
               'age2*sex',
               'Age_in_Yrs*sex')
solarPolygenic(as.formula(paste0('Cluster_MMHC', ' ~ ', paste0(covars_tri,
                                                               collapse=' + '))),
               hcp_df,
               covtest = TRUE)
####
# Network Analysis
# - Without Language Lateralization as covariate
trait_list = colnames(hcp_df)[19:39]
h2_MMHC_control = calc_net_heritability(df = hcp_df, 
                                        trait_list = trait_list, 
                                        covars = covars_tri)
dim(h2_MMHC_control)
# write.csv(h2_MMHC_control, file="h2_MMHCtri_network_withoutMMHC.csv")
####
