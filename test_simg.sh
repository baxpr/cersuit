#!/bin/bash

singularity run \
  --contain \
  --cleanenv \
  --home $(pwd)/OUTPUTS \
  --bind OUTPUTS:/tmp \
  --bind INPUTS:/INPUTS \
  --bind OUTPUTS:/OUTPUTS \
  baxpr-cersuit-master-v1.0.5.simg \
  out_dir /OUTPUTS \
  t1_niigz /INPUTS/T1.nii.gz \
  maskp 0.2 \
  project TESTPROJ \
  subject TESTSUBJ \
  session TESTSESS \
  scan TESTSCAN

