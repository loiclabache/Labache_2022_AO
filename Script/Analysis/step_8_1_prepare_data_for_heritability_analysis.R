library(tidyverse)
library(here)
library(gifti)
library(R.matlab)
library(solarius)
library(readxl)

# This script will:
#   1. Create a zygosity variable, combined from self-reported/genotyped columns
#   2. Remove single family with an implausible family structure
#   3. Create family relatedness columns in format compatible with SOLAR
#   4. If usable data is only available for one individual from a pair, reassign them as 'singleton'
#   5. Compile total cortical surface area estimates directly from Freesurfer output
#   6. Save dataframe as "hcp_for_solar.csv"

# read/combine HCP phenotype data
# ---------------
setwd(here())
hcp_pheno = read_excel(here("Data", 'data_demog_hcp.xlsx'))

# create a composite zygosity measure
# (prioritize genotyped vs self-reported)
# ---------------
zyg_comb = as.character(hcp_pheno[['ZygosityGT']])
zyg_comb[!zyg_comb %in% c('MZ','DZ')] = NA

self_report_zyg = as.character(hcp_pheno[['ZygositySR']])
zyg_comb[which(is.na(zyg_comb))] = self_report_zyg[which(is.na(zyg_comb))]
zyg_comb[which(zyg_comb == 'NotMZ')] = 'DZ'

hcp_pheno$Zyg_combined = zyg_comb

# get rid of subjects without zygosity status
hcp_pheno = hcp_pheno %>% filter(Zyg_combined != ' ')
dim(hcp_pheno)

# this family has monozygotic twins with two fathers?
hcp_pheno = hcp_pheno %>% filter(Family_ID != '56096_85916_99972')
dim(hcp_pheno)

# create id with father/mother combo
hcp_pheno$fa_mo_id = paste0(hcp_pheno$Father_ID, '_', hcp_pheno$Mother_ID)

# add MZ TWIN column/coding needed for SOLAR
# ---------------------
hcp_pheno$MZTWIN = ''
mz_moms = unique(hcp_pheno$Mother_ID[which(hcp_pheno$Zyg_combined == 'MZ')])
for (mom in mz_moms){
  mo_idxs = which(hcp_pheno$Mother_ID == mom)
  mz_idxs = which(hcp_pheno$Zyg_combined == 'MZ')
  idxs    = intersect(mo_idxs, mz_idxs)
  mz_id   = paste(hcp_pheno$Participant[idxs], collapse='_')
  hcp_pheno$MZTWIN[idxs] = mz_id
}
mz_table = table(hcp_pheno$MZTWIN)
mz_table = sort(mz_table)

# turn unmatched MZ/DZ twins into singletons
# ---------------------
singleton_mzs = names(mz_table[mz_table==1])

# mark singleton MZ subjects as not-twin
hcp_pheno$Zyg_combined[which(hcp_pheno$MZTWIN %in% singleton_mzs)] = 'NotTwin'
hcp_pheno$MZTWIN[hcp_pheno$MZTWIN %in% singleton_mzs] = ''

# turn unmatched DZ twins to singletons
dz_fam_table  = sort(table(as.character(hcp_pheno$fa_mo_id[hcp_pheno$Zyg_combined == 'DZ'])))
singleton_dzs = names(dz_fam_table[dz_fam_table == 1])

hcp_pheno$Zyg_combined[which(hcp_pheno$fa_mo_id %in% singleton_dzs)] = 'NotTwin'
hcp_pheno$MZTWIN[hcp_pheno$fa_mo_id %in% singleton_dzs] = ''

# create more variables required for SOLAR
# ---------------------
hcp_solar    = hcp_pheno
hcp_solar$fa = as.numeric(hcp_solar$Father_ID)
hcp_solar$mo = as.numeric(hcp_solar$Mother_ID)

# create solarius compatable family ID
hcp_solar$fam_id2 = paste0(hcp_solar$Mother_ID, '_', hcp_solar$Father_ID)
hcp_solar$famid = ""
ct = 1
for (id in unique(hcp_solar$fam_id2)){
  hcp_solar$famid[hcp_solar$fam_id2 == id] = ct
  ct = ct + 1
}

# create solarius compatable MZ twin marker
ct = 1
hcp_solar$mztwin = ""
for (id in unique(hcp_solar$MZTWIN)[unique(hcp_solar$MZTWIN) != '']){
  hcp_solar$mztwin[which(hcp_solar$MZTWIN == id)] = ct
  ct = ct + 1
}
hcp_solar$id  = hcp_solar$Participant
hcp_solar$sex = hcp_solar$Gender
keep_twins    = names(table(hcp_solar$mztwin)[table(hcp_solar$mztwin) != 1])
hcp_solar     = hcp_solar[hcp_solar$mztwin %in% keep_twins,]
hcp_solar$MZTWIN = NULL


hcp_solar$rel_group = hcp_solar$Zyg_combined
singleton_familys   = names(table(hcp_solar$famid)[table(hcp_solar$famid) == 1])
hcp_solar$rel_group[hcp_solar$famid %in% singleton_familys] = 'Singleton'
hcp_solar$Zyg_combined[hcp_solar$famid %in% singleton_familys] = 'NotTwin'

# check group assignments
sort(table(hcp_solar$fa_mo_id[which(hcp_solar$rel_group == 'MZ')]))
sort(table(hcp_solar$fa_mo_id[which(hcp_solar$rel_group == 'DZ')]))
sort(table(hcp_solar$fa_mo_id[which(hcp_solar$rel_group == 'Singleton')]))

# Group-wise estimates of covariates
# ----------------------
hcp_solar %>%
  group_by(rel_group) %>%
  summarize(n_obs=length(Age_in_Yrs),
              m_age = mean(Age_in_Yrs), sd_age = sd(Age_in_Yrs),
              fem_perc = mean(ifelse(Gender=='F',1,0)),
              m_int = mean(CogFluidComp_AgeAdj, na.rm=T), 
            sd_int = sd(CogFluidComp_AgeAdj, na.rm=T))


summary(aov(Age_in_Yrs ~ rel_group, data=hcp_solar))
hcp_solar$Gender_bin = ifelse(hcp_solar$Gender == 'M', 1, 0)
summary(aov(Gender_bin ~ rel_group, data=hcp_solar))
summary(aov(CogFluidComp_AgeAdj ~ rel_group, data=hcp_solar))

# select key columns and write to disk
# ----------------------
keep_cols = c('id','Age_in_Yrs','mztwin','sex','famid','fa','mo',
              'Ethnicity','Handedness','Height','Weight','BMI',
              'rel_group', 
              
              'STORYminusMath_SentCore_Asym', 'STORYminusMath_Hubs_Asym',
              'DC_Asym', 'DC_Sum', 'fisherTransform_r_interHemi',
              'Cont - Asym - Std', 'Default - Asym - Std',
              'DorsAttn - Asym - Std', 'Limbic - Asym - Std',
              'SalVentAttn - Asym - Std', 'SomMot - Asym - Std',
              'Vis - Asym - Std',
              'Cluster - MMHC binaire (category)',
              'NEOFAC_N','CogFluidComp_Unadj','FS_InterCranial_Vol')

hcp_solar_write = hcp_solar[keep_cols]
write_csv(hcp_solar_write, paste0(base_dir, '/hcp_for_solar_AtypSubjects.csv'))


