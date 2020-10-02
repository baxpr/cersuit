#!/bin/bash

# Main SUIT pipeline
singularity run \
  --contain \
  --cleanenv \
  --home $(pwd)/OUTPUTS \
  --bind OUTPUTS:/tmp \
  --bind INPUTS:/INPUTS \
  --bind OUTPUTS:/OUTPUTS \
  baxpr-cersuit-master-v2.0.2.simg \
  out_dir /OUTPUTS \
  t1_niigz /INPUTS/T1.nii.gz \
  gm_niigz /INPUTS/gm.nii.gz \
  maskp 0.2 \
  project TESTPROJ \
  subject TESTSUBJ \
  session TESTSESS \
  scan TESTSCAN

exit 0


# Warp an image from T1 native to SUIT space
singularity exec \
  --contain \
  --cleanenv \
  --home $(pwd)/OUTPUTS2 \
  --bind OUTPUTS2:/tmp \
  --bind OUTPUTS:/INPUTS \
  --bind OUTPUTS2:/OUTPUTS \
  baxpr-cersuit-master-v2.0.2.simg \
  xwrapper.sh function transform_native_to_SUIT \
  out_dir /OUTPUTS \
  src_niigz /INPUTS/testt1.nii.gz \
  mask_niigz /INPUTS/c_rt1_pcereb.nii.gz \
  coreg_txt /INPUTS/init_coreg_mat.txt \
  affine_mat /INPUTS/Affine_c_rt1_seg1.mat \
  flow_niigz /INPUTS/u_a_c_rt1_seg1.nii.gz \
  interp 1 \
  jactransf 0
  
exit 0


# Warp an image from SUIT space to T1 native space
singularity exec \
  --contain \
  --cleanenv \
  --home $(pwd)/OUTPUTS2 \
  --bind OUTPUTS2:/tmp \
  --bind OUTPUTS:/INPUTS \
  --bind OUTPUTS2:/OUTPUTS \
  baxpr-cersuit-master-v2.0.2.simg \
  xwrapper.sh function transform_SUIT_to_native \
  out_dir /OUTPUTS \
  src_nii /INPUTS/MNI152_T1_1mm.nii.gz \
  mask_nii /INPUTS/c_rt1_pcereb.nii.gz \
  coreg_txt /INPUTS/init_coreg_mat.txt \
  affine_mat /INPUTS/Affine_c_rt1_seg1.mat \
  flow_nii /INPUTS/u_a_c_rt1_seg1.nii.gz \
  interp 1
  
exit 0

