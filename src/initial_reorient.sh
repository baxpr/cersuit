#!/bin/bash

export FSLOUTPUTTYPE=NIFTI
${FSLDIR}/bin/fslreorient2std t1 t1_ro
mv t1_ro.nii t1.nii

