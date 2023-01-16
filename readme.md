Atypical language network lateralization is reflected throughout the
macroscale functional organization of cortex
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
<img src="Figures/gradient_effect.png" width="75%" height="75%" />
</p>

------------------------------------------------------------------------

## Code release

The `Script` folder contains 4 files:

- `-.rtf`: README file containing information about -
- `-`: —
- `-`: —
- **-**.

------------------------------------------------------------------------

## Data

All the data used are brain fMRI data from the Human Connectome Project
(HCP; n=995).

- The primary data used are the 5 functional features characterizing the
  high-order language network (see
  [SENSAAS](https://github.com/loiclabache/SENSAAS_brainAtlas)). These 5
  features have been previously shown to accurately determine the
  language network lateralization at the individual level ([Labache et
  al, 2020](https://doi.org/10.7554/eLife.58722)).

<p align="center">
<img src="Figures/method_summary.png" width="60%" height="60%" />
</p>

- The second set of data used are the region-level functional
  connectivity matrices (384 × 384
  [AICHA](https://doi.org/10.1016/j.jneumeth.2015.07.013) brain
  regions). Those matrices have been used to compute the first 3
  functional gradients ([Margulies et al,
  2016](https://doi.org/10.1073/pnas.1608282113)).

<p align="center">
<img src="Figures/gradients_summary.png" width="60%" height="60%" />
</p>

------------------------------------------------------------------------

## Atlas

- [SENSAAS](https://github.com/loiclabache/SENSAAS_brainAtlas) is 18
  regions of interest corresponding to the **core language network**
  have been selected from the language atlas. The core language network
  corresponded to a set of heteromodal brain regions *significantly
  involved, leftward asymmetrical across 3 language contrasts*
  (listening to, reading, and producing sentences), and intrinsically
  connected.

<p align="center">
<img src="Figures/sensaas.gif" width="50%" height="50%" />
</p>

- [AICHA](https://doi.org/10.1016/j.jneumeth.2015.07.013) is an
  **homotopic** brain atlas a functional brain atlas optimized for the
  *study of functional brain asymmetries*

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
