function mtx_file = init_coreg_translation_only(src_nii,out_dir)

% src and tgt should be a single volume (3D). We will capture and combine
% the COM shift and the coreg to save the initial 6 DOF transformation
% matrix that will be required before applying the estimated deformation
% later.	

% Make target gray matter from MNI atlas
gm_nii = [spm('dir') '/tpm/TPM.nii,1'];
gmV = spm_vol(gm_nii);
gm = spm_read_vols(gmV);
tgtV = rmfield(gmV,'pinfo');
tgt_nii = [out_dir '/coreg_tgt.nii'];
tgtV.fname = tgt_nii;
spm_write_vol(tgtV,gm);

% Find image centers of mass
tgt_com = find_center_of_mass(tgt_nii);
src_com = find_center_of_mass(src_nii);

% How to move the src image
src_shift = tgt_com - src_com;
src_shift_mat = spm_matrix(src_shift);

% SPM file handles
srcV = spm_vol(src_nii);
tgtV = spm_vol(tgt_nii);

% Update the src geometry with the COM matrix
srcV.mat = src_shift_mat * srcV.mat;

% Combined matrix
total_mat = src_shift_mat;

% Save matrix to file
mtx_file = [out_dir '/init_coreg_mat.txt'];
save(mtx_file,'total_mat','-ascii');

