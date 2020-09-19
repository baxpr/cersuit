#!/bin/bash
#
# PDF for QA check

echo Making PDF

# FSL init
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh

# Work in output directory
cd ${OUTDIR}

# Create views
fsleyes render -of atlas_over_gray.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg1 --overlayType volume --displayRange 0.0 1.5 \
  Lobules-SUIT --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of atlas_over_white.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg2 --overlayType volume --displayRange 0.0 1.5 \
  Lobules-SUIT --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_gray.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg1 --overlayType volume --displayRange 0.0 1.5 \
  wc_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_white.png \
  --scene ortho --worldLoc 0.0 -56.0 -33.0 --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg2 --overlayType volume --displayRange 0.0 1.5 \
  wc_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

# Combine into single PDF
${IMMAGDIR}/montage \
-mode concatenate \
mask_over_gray.png mask_over_white.png \
atlas_over_gray.png atlas_over_white.png \
-tile 1x4 -trim -quality 100 -background black -gravity center \
-border 20 -bordercolor black images.png

info_string="$PROJECT $SUBJECT $SESSION $SCAN"
${IMMAGDIR}/convert \
-size 2600x3365 xc:white \
-gravity center \( images.png -resize 2400x \) -composite \
-gravity North -pointsize 48 -annotate +100+100 \
"SUIT Cerebellar Segmentation, modulated images in atlas space" \
-gravity SouthEast -pointsize 48 -annotate +100+100 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
cersuit.pdf


