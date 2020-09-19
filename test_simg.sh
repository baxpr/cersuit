#!/bin/bash

singularity run \
  --contain \
  --cleanenv \
  --home $(pwd)/INPUTS \
  --bind /tmp:/tmp \
  --bind INPUTS:/INPUTS \
  --bind OUTPUTS:/OUTPUTS \
  container.simg \
  t1_niigz INPUTS/T1.nii.gz \
  maskp 0.2 \
  project TESTPROJ \
  subject TESTSUBJ \
  session TESTSESS \
  scan TESTSCAN

