# cersuit

Cerebellar segmentation with the [SUIT atlas and toolbox](http://diedrichsenlab.org/imaging/suit.htm). In the container, the pipeline is installed in the `/opt/cersuit` directory. Matlab code is in the `src` directory, and the entrypoint is `src/cersuit.m`. Compiled Matlab code for use in the singularity container without a Matlab license is in `bin`.

See the `external` directory for links, references, and license information for the underlying SPM12 and SUIT Matlab software. [FSL version 6.0.2](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) is also used for image file manipulation and creating the QA PDF.

The container has a full installation of both SPM12 (compiled) and FSL. However, the SPM12 GUI will probably not run correctly due to some missing graphics libraries in the container OS.


## References for SUIT

- [Diedrichsen, J. (2006). A spatially unbiased atlas template of the human cerebellum. Neuroimage, 33, 1, p. 127-138.](https://doi.org/10.1016/j.neuroimage.2006.05.056)

- [Diedrichsen, J., Balsters, J. H., Flavell, J., Cussans, E., & Ramnani, N. (2009). A probabilistic atlas of the human cerebellum. Neuroimage 46(1):39-46.](https://doi.org/10.1016/j.neuroimage.2009.01.045)

- [Diedrichsen, J., Maderwald, S., Kuper, M., Thurling, M., Rabe, K., Gizewski, E. R., et al. (2011). Imaging the deep cerebellar nuclei: A probabilistic atlas and normalization procedure. Neuroimage 54(3):1786-94](https://doi.org/10.1016/j.neuroimage.2010.10.035)

- [Diedrichsen, J. & Zotow, E. (2015). Surface-based display of volume-averaged cerebellar data. PLoS One, 7, e0133402.](https://doi.org/10.1371/journal.pone.0133402)


## Pipeline

- Rigid body coregistration

- ...



## Usage of the singularity container


### Main processing pipeline

    singularity run --contain --cleanenv \
      --home <temporary-home-dir> \
      --bind <tmp-dir>:/tmp \
      --bind <input-dir>:/INPUTS \
      --bind <output-dir>:/OUTPUTS \
      <cersuit-container-name>.simg \
      out_dir /OUTPUTS \
      t1_niigz /INPUTS/<t1-niigz-filename> \
      maskp <mask-threshold> \
      project <project-name> \
      subject <subject-name> \
      session <session-name> \
      scan <scan-name>

### Apply an estimated warp to additional images


(This can also be done directly with the ??? matlab functions in `src`).


## Parameters and inputs

    <temporary-home-dir>      Matlab will use this for temp files
    <tmp-dir>                 Other location for temp files          
    <input-dir>               Directory containing the input T1 image file
    <output-dir>              Outputs will be stored here
    <t1-niigz-filename>       Filename of the input T1 - expecting <something>.nii.gz
    <mask-threshold>          SPM mask threshold for separating brain from background
    <project-name>            Project/subject/session/scan names from XNAT, if XNAT is
    <subject-name>               used. These are only used to decorate the PDF report.
    <session-name>    
	<scan-name>


## Outputs

PDF report for quality assurance

    PDF               cersuit.pdf

Transformation from native to atlas space. Apply in this order

    RIGID             coreg_t1_to_mni.mat
    AFFINE            Affine_c_t1_seg1.mat
    FLOWFIELD         u_a_c_t1_seg1.nii.gz

Cropped T1 in both spaces

    T1_CROP_NATIVE    c_t1.nii.gz
    T1_CROP_SUIT      wc_t1.nii.gz

Cerebellum mask, segmented gray matter and white matter volume fraction images in native and atlas space

    MASK_NATIVE       c_t1_pcereb.nii.gz
    GRAY_NATIVE       c_t1_seg1.nii.gz
    WHITE_NATIVE      c_t1_seg2.nii.gz
    MASK_SUIT         wc_t1_pcereb.nii.gz
    GRAY_SUIT         wc_t1_seg1.nii.gz
    WHITE_SUIT        wc_t1_seg2.nii.gz

Jacobian-modulated gray and white matter images in atlas space

    GRAYMOD_SUIT      wdc_t1_seg1.nii.gz
    WHITEMOD_SUIT     wdc_t1_seg2.nii.gz

Segmented regions in native and atlas space, with lookup table

    SEG_NATIVE        iw_Lobules-SUIT_u_a_c_t1_seg1.nii.gz
    SEG_SUIT          Lobules-SUIT.nii.gz
    SEG_LUT           Lobules-SUIT-lut.txt

Volumetry of segmented regions, computed from native space images. The "Total" is the volume of the atlas region after transformation to native space. The "Gray" is the sum of voxel gray matter fraction within the atlas region, in native space; similar for "White".

    SEG_NATIVE_VOLS   iw_Lobules-SUIT_u_a_c_t1_seg1-volumes.csv

