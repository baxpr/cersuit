# cersuit

Cerebellar segmentation with the [SUIT atlas and toolbox](http://diedrichsenlab.org/imaging/suit.htm). In the container, the pipeline is installed in the `/opt/cersuit` directory. Matlab code is in the `src` directory, and the entrypoint is `src/cersuit.m`. Compiled Matlab code for use in the singularity container without a Matlab license is in `bin`.

See the `external` directory for links, references, and license information for the underlying SPM12 and SUIT Matlab software. [FSL version 6.0.2](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) is also used for image file manipulation and creating the QA PDF.

The container has a full installation of both SPM12 (compiled) and FSL.


## References for SUIT

- [Diedrichsen, J. (2006). A spatially unbiased atlas template of the human cerebellum. Neuroimage, 33, 1, p. 127-138.](https://doi.org/10.1016/j.neuroimage.2006.05.056)

- [Diedrichsen, J., Balsters, J. H., Flavell, J., Cussans, E., & Ramnani, N. (2009). A probabilistic atlas of the human cerebellum. Neuroimage 46(1):39-46.](https://doi.org/10.1016/j.neuroimage.2009.01.045)

- [Diedrichsen, J., Maderwald, S., Kuper, M., Thurling, M., Rabe, K., Gizewski, E. R., et al. (2011). Imaging the deep cerebellar nuclei: A probabilistic atlas and normalization procedure. Neuroimage 54(3):1786-94](https://doi.org/10.1016/j.neuroimage.2010.10.035)

- [Diedrichsen, J. & Zotow, E. (2015). Surface-based display of volume-averaged cerebellar data. PLoS One, 7, e0133402.](https://doi.org/10.1371/journal.pone.0133402)


## Pipeline

- Adjustment of the source T1 file to axial data ordering using fslreorient2std, to meet a requirement of the SUIT toolbox.

- Rigid body coregistration of the supplied gray matter image to SPM12's gray matter probabilistic atlas (TPM.nii). The supplied gray matter image must be in register with the supplied T1. The estimated registration is saved to file and also applied to the T1.

- SUIT estimation of the affine transformation and warp of the cerebellar area of the T1 to the SUIT atlas.

- Resampling of the T1 and related images to the SUIT atlas space. Gray matter and white matter images are resampled both with and without modulation by the Jacobian.

- Resampling of the SUIT-supplied atlases to the original T1 native space.

- Computation of regional volumes for the Lobules_SUIT atlas in the native T1 space.


## Usage of the singularity container

See `singularity_examples.sh` for examples of using the container for SUIT warp estimation, and transformation from native to SUIT space and back using an existing estimated warp. The transformations can also be done directly from matlab with the `transform_???.m` functions in `src`).


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

    ATLASES_NATIVE    SUIT-supplied atlases resampled to original T1 space
    ATLASES_SUIT      The SUIT-supplied atlases themselves

Volumetry of segmented regions, computed from native space images. The "Total" is the volume of the atlas region after transformation to native space. The "Gray" is the sum of voxel gray matter fraction within the atlas region, in native space; similar for "White".

    NATIVE_VOLS       iw_Lobules-SUIT_u_a_c_t1_seg1-volumes.csv

