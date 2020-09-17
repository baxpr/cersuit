spm fmri
 
suit_isolate_seg({'T1.nii'}); % default mask probability is 0.2, can use 'maskp' to create tighter mask
 
job = struct();
job.subjND(1).gray = {'T1_seg1.nii'};
job.subjND(1).white = {'T1_seg2.nii'};
job.subjND(1).isolation = {'c_T1_pcereb.nii'};
suit_normalize_dartel(job);
 
job = struct();
job.subj.affineTr = {'Affine_T1_seg1.mat'};
job.subj.flowfield = {'u_a_T1_seg1.nii'};
job.subj.resample = {'T1_seg1.nii'}; % should be _seg1 file (grey segmentation) if doing VBM
job.subj.mask = {'c_T1_pcereb.nii'};
job.interp = 1;
job.jactransf = 1 % 1 for VBM and 0 for fMRI
suit_reslice_dartel(job); % output image is wdXXX_seg1.nii that can be used for VBM
 
job = struct();
job.subj.affineTr = {'Affine_T1_seg1.mat'};
job.subj.flowfield = {'u_a_T1_seg1.nii'};
job.subj.resample = {'T1.nii'};
job.subj.mask = {'c_T1_pcereb.nii'};
job.interp = 1
job.jactransf = 0
suit_reslice_dartel(job); % output image is wdXXX.nii that can be used for group stats (normalized)
 
job = struct();
job.Affine = {'Affine_T1_seg1.mat'};
job.flowfield = {'u_a_T1_seg1.nii'};
job.resample = {'Lobules-SUIT.nii'}; % can select any atlas of interest (including King functional atlas)
job.ref = {'T1.nii'};
suit_reslice_dartel_inv(job) % output image is iw_ and is in subject space
 
V=suit_vol('iw_Lobules-SUIT_u_a_T1_seg1.nii', 'Atlas') % generates voxel num and vol for each lobule (VolumeData)
V_data = [(V.vox)' (V.vmm)']
dlmwrite('VolumeData', V_data)
 