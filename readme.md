Language network lateralization is reflected throughout the macroscale
functional organization of cortex
================

## Reference

**Labache, L.**, Ge, T., Yeo, B.T. T., Holmes, A. J. (2022). Atypical
language network lateralization is reflected throughout the macroscale
functional organization of cortex. bioRxiv. DOI:
[10.1101/2022.12.14.520417](https://doi.org/10.1101/2022.12.14.520417)

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
organization exhibited corresponding hemispheric differences in the
macroscale functional gradients that situate discrete large-scale
networks along a continuous spectrum, extending from unimodal through
association territories. Analyses revealed that both language
lateralization and gradient asymmetries are, in part, driven by genetic
factors. These findings pave the way for a deeper understanding of the
origins and relationships linking population-level variability in
hemispheric specialization and global properties of cortical
organization.

<p align="center">
<img src="readme_files/gradient_effect.png" width="75%" height="75%" />
</p>

------------------------------------------------------------------------

## Code release (*in progress*)

The `Script` folder contains 2 sub-folders: `Analysis` and
`Visualization`.

The `Analysis` folder contains the scripts to download resting-state and
language task fMRI data (from the Amazon Web Services: AWS, S3 bucket),
compute language lateralization metrics and gradients, and analyze data.

- `step_1_download_rest_fMRI_HCP_data.R`: `R` script to download
  resting-state data for chosen participants. Requires to create AWS
  credentials through the
  [ConnectomeDB](https://wiki.humanconnectome.org/display/PublicData/How+To+Connect+to+Connectome+Data+via+AWS)
  website.
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
  language lateralization metrics (data available in the `Data` folder:
  `995participants_language_metrics_HCP.csv`):
  - average asymmetry of activation (left-right hemisphere) of the
    story-math fMRI contrast at the **network** level,
  - average asymmetry of activations (left-right hemisphere) of the
    story-math fMRI contrast at the **hub** level,
  - average strength sum (left+right hemisphere) during rs-fMRI of the
    language network,
  - average strength asymmetry (left-right hemisphere) during rs-fMRI of
    the language network,
  - average inter-hemispheric homotopic connectivity strength during
    rs-fMRI of the language network.
- `step_5_participants_classification.R`: …

The `Visualization` folder contains `R` files (`figures_script_FigX.R`)
used to generate each figures included in the paper. Each script
corresponds to a figure or a panel. The brain renderings in the paper
require a customized version of [Surf
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
  `Data\995participants_language_metrics_HCP.csv` (participants
  identifiers are anonymized).

<p align="center">
<img src="readme_files/method_summary.png" width="60%" height="60%" />
</p>

- The second set of data used are the region-level functional
  connectivity matrices (384 × 384
  [AICHA](https://doi.org/10.1016/j.jneumeth.2015.07.013) brain
  regions). Those matrices have been used to compute the first 3
  functional gradients ([Margulies, D., et
  al. 2016](https://doi.org/10.1073/pnas.1608282113)).

<p align="center">
<img src="readme_files/gradients_summary.png" width="60%" height="60%" />
</p>

All data computed in the paper and to generate figures are provided in
`Data` folder.

The file `Data\infos_995participants.csv` does not correspond to the HCP
identifiers of each participant, but an exemple file to run the scripts.

------------------------------------------------------------------------

## Atlas used

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
    - Briefly, the language network hubs atlas corresponded to the
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
