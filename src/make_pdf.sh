#!/bin/bash
#
# PDF for QA check

PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH
. ${FSLDIR}/etc/fslconf/fsl.sh


fsleyes render -of atlas_over_gray.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor \
  wdc_t1_seg1 --overlayType volume --displayRange 0.0 1.5 \
  Lobules-SUIT --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of atlas_over_white.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor \
  wdc_t1_seg2 --overlayType volume --displayRange 0.0 1.5 \
  Lobules-SUIT --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_gray.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor \
  wdc_t1_seg1 --overlayType volume --displayRange 0.0 1.5 \
  wc_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_white.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor \
  wdc_t1_seg2 --overlayType volume --displayRange 0.0 1.5 \
  wc_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

