#!/bin/bash
cd /Applications/workbench/bin_macosx64
home='/tfMRI_LANGUAGE'
# bash wb_command -volume-to-surface-mapping "$home"/SENTcore_SENSAAS_atlas/binarySentCore_volume.nii.gz "$home"/Individual_template/L.midthickness.32k_fs_LR.surf.gii "$home"/SENTcore_SENSAAS_atlas/binarySentCore_L_surface.shape.gii -enclosing
bash wb_command -cifti-separate "$home"/Activation/participantID_tfMRI_LANGUAGE_level2_hp200_s4.dscalar.nii COLUMN -metric CORTEX_LEFT "$home"/Activation_by_hemisphere/participantID_CORTEX_LEFT_tfMRI_LANGUAGE_level2_hp200_s4.shape.gii
bash wb_command -cifti-separate "$home"/Activation/participantID_tfMRI_LANGUAGE_level2_hp200_s4.dscalar.nii COLUMN -metric CORTEX_RIGHT "$home"/Activation_by_hemisphere/participantID_CORTEX_RIGHT_tfMRI_LANGUAGE_level2_hp200_s4.shape.gii
