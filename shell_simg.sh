#!/bin/bash

singularity shell \
  --contain \
  --cleanenv \
  --home $(pwd)/OUTPUTS \
  --bind OUTPUTS:/tmp \
  --bind INPUTS:/INPUTS \
  --bind OUTPUTS:/OUTPUTS \
  baxpr-cersuit-master-v1.0.3.simg

