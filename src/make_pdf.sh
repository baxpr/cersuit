#!/bin/bash
#
# PDF for QA check

echo Making PDF

# FSL init
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh

# Work in output directory
cd ${OUTDIR}

# Create medial views, atlas space
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

# Create lateral views, atlas space
fsleyes render -of atlas_over_gray_2.png \
  --scene ortho --worldLoc 32 -42 -52 --displaySpace world \
  --xcentre 0 0 --ycentre 0 0 --zcentre 0 0 \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg1 --overlayType volume --displayRange 0.0 1.5 \
  Lobules-SUIT --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of atlas_over_white_2.png \
  --scene ortho --worldLoc 32 -42 -52 --displaySpace world \
  --xcentre 0 0 --ycentre 0 0 --zcentre 0 0 \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg2 --overlayType volume --displayRange 0.0 1.5 \
  Lobules-SUIT --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_gray_2.png \
  --scene ortho --worldLoc 32 -42 -52 --displaySpace world \
  --xcentre 0 0 --ycentre 0 0 --zcentre 0 0 \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg1 --overlayType volume --displayRange 0.0 1.5 \
  wc_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_white_2.png \
  --scene ortho --worldLoc 32 -42 -52 --displaySpace world \
  --xcentre 0 0 --ycentre 0 0 --zcentre 0 0 \
  --layout horizontal --hideCursor --hideLabels \
  wdc_t1_seg2 --overlayType volume --displayRange 0.0 1.5 \
  wc_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

# Medial views, native space
maskcom=$(fslstats c_t1_pcereb -c)

fsleyes render -of atlas_over_gray_native.png \
  --scene ortho --worldLoc $maskcom --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg1 --overlayType volume --displayRange 0 1 \
  iw_Lobules-SUIT_u_a_c_t1_seg1 --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of atlas_over_white_native.png \
  --scene ortho --worldLoc $maskcom --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg2 --overlayType volume --displayRange 0 1 \
  iw_Lobules-SUIT_u_a_c_t1_seg1 --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_gray_native.png \
  --scene ortho --worldLoc $maskcom --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg1 --overlayType volume --displayRange 0 1 \
  c_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_white_native.png \
  --scene ortho --worldLoc $maskcom --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg2 --overlayType volume --displayRange 0 1 \
  c_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2


# Lateral views, native space

# Split xyz coords and edit
XYZ=(${maskcom// / })
X=$(echo "${XYZ[0]} + 30" | bc -l)
Y=$(echo "${XYZ[1]} + 12" | bc -l)
Z=$(echo "${XYZ[2]} +-18" | bc -l)

fsleyes render -of atlas_over_gray_native_2.png \
  --scene ortho --worldLoc $X $Y $Z --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg1 --overlayType volume --displayRange 0 1 \
  iw_Lobules-SUIT_u_a_c_t1_seg1 --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of atlas_over_white_native_2.png \
  --scene ortho --worldLoc $X $Y $Z --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg2 --overlayType volume --displayRange 0 1 \
  iw_Lobules-SUIT_u_a_c_t1_seg1 --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_gray_native_2.png \
  --scene ortho --worldLoc $X $Y $Z --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg1 --overlayType volume --displayRange 0 1 \
  c_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2

fsleyes render -of mask_over_white_native_2.png \
  --scene ortho --worldLoc $X $Y $Z --displaySpace world \
  --layout horizontal --hideCursor --hideLabels \
  c_t1_seg2 --overlayType volume --displayRange 0 1 \
  c_t1_pcereb --overlayType label --lut random --outline --outlineWidth 2



# Combine into single PDF
${IMMAGDIR}/montage \
-mode concatenate \
mask_over_gray.png mask_over_white.png \
atlas_over_gray.png atlas_over_white.png \
-tile 1x4 -trim -quality 100 -background black -gravity center \
-border 20 -bordercolor black page1.png

${IMMAGDIR}/montage \
-mode concatenate \
mask_over_gray_2.png mask_over_white_2.png \
atlas_over_gray_2.png atlas_over_white_2.png \
-tile 1x4 -trim -quality 100 -background black -gravity center \
-border 20 -bordercolor black page2.png

${IMMAGDIR}/montage \
-mode concatenate \
mask_over_gray_native.png mask_over_white_native.png \
atlas_over_gray_native.png atlas_over_white_native.png \
-tile 1x4 -trim -quality 100 -background black -gravity center \
-border 20 -bordercolor black page3.png

${IMMAGDIR}/montage \
-mode concatenate \
mask_over_gray_native_2.png mask_over_white_native_2.png \
atlas_over_gray_native_2.png atlas_over_white_native_2.png \
-tile 1x4 -trim -quality 100 -background black -gravity center \
-border 20 -bordercolor black page4.png

info_string="$PROJECT $SUBJECT $SESSION $SCAN"
${IMMAGDIR}/convert \
-size 2600x3365 xc:white \
-gravity center \( page1.png -resize 2400x \) -composite \
-gravity North -pointsize 48 -annotate +0+100 \
"SUIT Cerebellar Segmentation, modulated images in atlas space" \
-gravity SouthEast -pointsize 48 -annotate +100+100 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
page1.png

${IMMAGDIR}/convert \
-size 2600x3365 xc:white \
-gravity center \( page2.png -resize 2400x \) -composite \
-gravity North -pointsize 48 -annotate +0+100 \
"SUIT Cerebellar Segmentation, modulated images in atlas space" \
-gravity SouthEast -pointsize 48 -annotate +100+100 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
page2.png

${IMMAGDIR}/convert \
-size 2600x3365 xc:white \
-gravity center \( page3.png -resize 2400x \) -composite \
-gravity North -pointsize 48 -annotate +0+100 \
"SUIT Cerebellar Segmentation, images in native space" \
-gravity SouthEast -pointsize 48 -annotate +100+100 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
page3.png

${IMMAGDIR}/convert \
-size 2600x3365 xc:white \
-gravity center \( page4.png -resize 2400x \) -composite \
-gravity North -pointsize 48 -annotate +0+100 \
"SUIT Cerebellar Segmentation, images in native space" \
-gravity SouthEast -pointsize 48 -annotate +100+100 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
page4.png

convert page1.png page2.png page3.png page4.png cersuit.pdf

