Language network lateralization is reflected throughout the macroscale
functional organization of cortex
================

[![DOI](https://zenodo.org/badge/589013041.svg)](https://zenodo.org/badge/latestdoi/589013041)
<!-- ![GitHub all releases](https://img.shields.io/github/downloads/loiclabache/Labache_2022_AO/total) -->

------------------------------------------------------------------------

## Contents

- [Background](#background)
- [Code Release](#code-release)
- [Data](#data)
- [Atlas Used](#atlas-used)
- [Reference](#reference)
- [Other related papers that might interest
  you](#other-related-papers-that-might-interest-you)
- [Questions](#questions)

------------------------------------------------------------------------

## Background

**Hemispheric specialization** is a fundamental feature of human brain
organization. However, it is not yet clear to what extent the
*lateralization of specific cognitive processes may be evident
throughout the broad functional architecture of cortex*. While the
majority of people exhibit left-hemispheric language dominance, a
substantial minority of the population shows reverse lateralization.
Using twin and family data from the Human Connectome Project, we provide
evidence that atypical **language dominance is associated with global
shifts in cortical organization**. Individuals with atypical language
organization exhibit corresponding hemispheric differences in the
macroscale functional gradients that situate discrete large-scale
networks along a continuous spectrum, extending from unimodal through
association territories. Analyses reveal that both language
lateralization and gradient asymmetries are, in part, driven by genetic
factors. These findings pave the way for a deeper understanding of the
origins and relationships linking population-level variability in
hemispheric specialization and global properties of cortical
organization.

<p align="center">
<img src="readme_files/gradient_effect.png" width="75%" height="75%" />
</p>

------------------------------------------------------------------------

## Code Release

The `Script` folder contains 2 sub-folders: `Analysis` and
`Visualization`.

The `Analysis` folder contains the scripts to download resting-state and
language task fMRI data (from the Amazon Web Services: AWS, S3 bucket),
compute language lateralization metrics and gradients, and analyze data.

- `step_1_download_rest_fMRI_HCP_data.R`: `R` script to download
  resting-state data for chosen participants. Requires to create AWS
  credentials through the
  [ConnectomeDB](https://wiki.humanconnectome.org/display/PublicData/How+To+Connect+to+Connectome+Data+via+AWS)
  website. Only the rs-BOLD time series from the language network
  (SENT_CORE) are downloaded.
- `step_2_download_task_fMRI_HCP_data.R`: `R` script to download
  language task data for chosen participants (*aka* files named
  *LANGUAGE_level2_hp200_s4.dscalar.nii* on HCP server). Requires to
  create AWS credentials through the
  [ConnectomeDB](https://wiki.humanconnectome.org/display/PublicData/How+To+Connect+to+Connectome+Data+via+AWS)
  website.
- `step_3_splitting_areal_tfMRI.sh`: `shell` script to split the fMRI
  activations of the language task between the left and right
  hemispheres. Requires
  [`Connectome Workbench`](https://www.humanconnectome.org/software/connectome-workbench).
- `step_4_language_metrics_computation.R`: `R` script to compute the 5
  language lateralization metrics for each participant (data available
  in the `Data` folder: `995participants_language_metrics_HCP.xlsx`):
  - **average asymmetry of activation** (left-right hemisphere) of the
    story-math fMRI contrast at the **network** level,
  - **average asymmetry of activation** (left-right hemisphere) of the
    story-math fMRI contrast at the **hub** level,
  - **average strength sum** (left+right hemisphere) during rs-fMRI of
    the language network,
  - **average strength asymmetry** (left-right hemisphere) during
    rs-fMRI of the language network,
  - **average inter-hemispheric homotopic connectivity strength** during
    rs-fMRI of the language network.
- `step_5_participants_classification.R`: `R` script to classify the 995
  participants. Each participant is characterized by the 5 language
  lateralization metrics.
- `step_6_whole_brain_fc_matrices.R`: `R` script to compute the whole
  brain connectivity matrix (384 x 384, AICHA atlas) for each
  participant.
- `step_7_1_gradient_computation.py`: `Python` script to compute the
  first 3 functional gradients as defined by ([Margulies, D., et
  al. 2016](https://doi.org/10.1073/pnas.1608282113)), using the
  `Python` library
  [*BrainSpace*](https://brainspace.readthedocs.io/en/latest/pages/getting_started.html).
  The script requires group level correlation matrix, available there:
  `Data/groupLevel_correlationMatrix.txt`, and the group level gradient
  values, available there:`Data/groupLevel_gradient.csv`.
- `step_7_2_gradient_computation.R`: `R` script to create a compiled
  file of all the gradient values for all participant. The normalized
  gradients at the network level for each participant can be found
  there: `Data/994participants_gradients_network.xlsx`. The
  correspondence between the AICHA regions and the 7 networks from [Yeo,
  B.T. T., et al. 2011](https://doi.org/10.1152/jn.00338.2011) can be
  found there:
  `Atlas/AICHA/overlap_AICHA_Yeo_7Network_maskYeo_SchaeferAtlas.csv`.
- `step_8_1_prepare_data_for_heritability_analysis.R`: `R` script to
  create an compatible csv file for `Solar`, a software allowing to
  perform heritability analysis.
- `step_8_2_heritability_gradient_network.R`: `R` script to perform the
  heritability analysis.

The `Visualization` folder contains `R` files (`FigX_script.R`) used to
generate each figures included in the paper. Each script corresponds to
a figure or a panel. The brain renderings in the paper require a
customized version of [Surf
Ice](https://www.nitrc.org/projects/surfice/) that we will be happy to
share on demand.

------------------------------------------------------------------------

## Data

All the data used are brain fMRI data from the Human Connectome Project
(HCP; *n*=995). The HCP data requires data access permission and if you
have this, we are happy to share the processed data used here.

- The primary data used are the 5 functional features characterizing the
  high-order language network (see
  [SENSAAS](https://github.com/loiclabache/SENSAAS_brainAtlas)). These 5
  features have been previously shown to accurately determine the
  language network lateralization at the individual level ([Labache, L.,
  et al. 2020](https://doi.org/10.7554/eLife.58722)). The 5 language
  lateralization metrics are availabe there:
  `Data\995participants_language_metrics_HCP.xlsx` (participants
  identifiers are anonymized).

<p align="center">
<img src="readme_files/method_summary.png" width="60%" height="60%" />
</p>

- The second set of data used are the region-level functional
  connectivity matrices (384 × 384
  [AICHA](https://doi.org/10.1016/j.jneumeth.2015.07.013) brain
  regions). Those matrices have been used to compute the first 3
  functional gradients ([Margulies, D., et
  al. 2016](https://doi.org/10.1073/pnas.1608282113)). The individual
  normalized network gradient values are available there:
  `Data/994participants_gradients_network.xlsx`.

<p align="center">
<img src="readme_files/gradients_summary.png" width="60%" height="60%" />
</p>

All data computed in the paper and to generate figures are provided in
`Data` folder.

The file `Data\infos_995participants.csv` does not correspond to the HCP
identifiers of each participant, but an exemple file to run the scripts.

------------------------------------------------------------------------

## Atlas Used

The atlas used in te paper are available in the `Atlas` folder. This
folder contains 2 sub-folders: `SENSAAS` and `AICHA`.

- **SENSAAS** provide an atlas in standardized MNI volume space of 32
  sentence-related areas based on a 3-step method combining the analysis
  of *activation and asymmetry during multiple language tasks* with
  hierarchical clustering of resting-state connectivity and graph
  analyses. The temporal correlations at rest between these 32 regions
  made it possible to detect their belonging to 3 networks. Among these
  networks, one, *including 18 regions*, contains the essential language
  areas (**SENT_CORE** network), *i.e.* those whose **lesion would cause
  an alteration in the understanding of speech**. Full description of
  the language atlas can be found there:
  [SENSAAS](https://github.com/loiclabache/SENSAAS_brainAtlas), and the
  related paper there: [Labache, L., et
  al. 2019](https://doi.org/10.1007/s00429-018-1810-2).
  - The *volumetric* (in the MNI ICBM 152 space) and *area* (32k_fs_LR
    space) atlas are available in the `Atlas/SENSAAS` folder. The
    sub-folder `Volumetric` contains the volumetric SENSAAS atlas:
    `SENSAAS_MNI_ICBM_152_2mm.nii`, and a CSV file containing a full
    description of each language areas: `SENSAAS_description.csv`. The
    sub-folder `Area` contains the area SENSAAS atlas in the left
    (`S1200_binarySentCore_L_surface.shape.gii`) and right hemisphere
    (`S1200_binarySentCore_R_surface.shape.gii`), as well as the hub
    atlas (*i.e.* regions STS3, STS4 and F3t only) in the left
    (`S1200_binaryHubsSentCore_L_surface.shape.gii`) and right
    hemisphere (`S1200_binaryHubsSentCore_R_surface.shape.gii`).
    - Briefly, the hub language network atlas corresponded to the
      inferior frontal gyrus (Broca’s area, F3t) and to the posterior
      aspect of the superior temporal sulcus (corresponding to
      Wernicke’s area, STS3 and STS4).

<p align="center">
<img src="readme_files/sensaas.gif" width="50%" height="50%" />
</p>

- **AICHA** is a functional brain ROIs atlas (384 brain regions) based
  on resting-state fMRI data acquired in 281 individuals. AICHA ROIs
  cover the whole cerebrum, each having 1) homogeneity of its
  constituting voxels intrinsic activity, and 2) a unique homotopic
  contralateral counterpart with which it has maximal intrinsic
  connectivity. Full description of the atlas can be found there:
  [AICHA](https://www.gin.cnrs.fr/en/tools/aicha/), and the related
  paper there: [Joliot, M., et
  al. 2015](https://doi.org/10.1016/j.jneumeth.2015.07.013).
  - The version of AICHA used in the paper is available in the
    `Atlas\AICHA` folder: `AICHA.nii` (MNI ICBM 152 space).
    `AICHA_vol3.txt` is a description of each atlas’ regions.
    `Readme_AICHA.pdf` is the user manual.

------------------------------------------------------------------------

## Reference

For usage of the ***manuscript***, please cite:

- **Labache, L.**, Ge, T., Yeo, B.T. T., Holmes, A. J. (2023). Language
  network lateralization is reflected throughout the macroscale
  functional organization of cortex. bioRxiv. DOI:
  [10.1101/2022.12.14.520417](https://doi.org/10.1101/2022.12.14.520417)

For usage of the associated ***code***, please also cite:

- **Labache, L.**, Ge, T., Yeo, B.T. T., Holmes, A. J. (2023). Language
  network lateralization is reflected throughout the macroscale
  functional organization of cortex. loiclabache/Labache_2022_AO. DOI:
  [10.5281/zenodo.7869040](https://doi.org/10.5281/zenodo.7869040)

------------------------------------------------------------------------

## Other related papers that might interest you

- Sentence Supramodal Areas Atlas:
  [SENSAAS](https://github.com/loiclabache/SENSAAS_brainAtlas)
- Typical and Atypical Language Brain Organization: Labache, L., et
  al. 2020. DOI:
  [10.7554/eLife.58722](https://doi.org/10.7554/eLife.58722)

------------------------------------------------------------------------

## Questions

Please contact me (Loïc Labache) as <loic.labache@yale.edu> and/or
<loic.labache@ensc.fr>
