function cersuit_main(inp)

% Copy input file to output dir
out_dir = inp.out_dir;
copyfile(inp.t1_niigz,fullfile(out_dir,'t1.nii.gz'))

% Work in the output directory with unzipped .nii
cd(out_dir);
system('gunzip t1.nii.gz');

% Reorient the input file to meet SUIT requirement for axial data ordering
system(['FSLDIR=' inp.fsl_dir ' ' inp.src_dir '/initial_reorient.sh']);

% We need SPM running
spm('fmri');

% Segment the cerebellum
suit_isolate_seg({'t1.nii'},'maskp',str2double(inp.maskp),'keeptempfiles',1);

% Estimate the atlas space warp
disp('Estimate warp')
job = struct();
job.subjND(1).gray = {'c_t1_seg1.nii'};
job.subjND(1).white = {'c_t1_seg2.nii'};
job.subjND(1).isolation = {'c_t1_pcereb.nii'};
suit_normalize_dartel(job);

% Create several images in SUIT atlas space, unmodulated, interpolated
disp('Resample images')
for m = {'c_t1.nii','c_t1_seg1.nii','c_t1_seg2.nii'}
	job = struct();
	job.subj.affineTr = {'Affine_c_t1_seg1.mat'};
	job.subj.flowfield = {'u_a_c_t1_seg1.nii'};
	job.subj.mask = {'c_t1_pcereb.nii'};
	job.subj.resample = m(1);
	job.interp = 1;
	job.jactransf = 0;
	suit_reslice_dartel(job);
	movefile(['wd' m{1}],['w' m{1}]);
end

% Create cer mask atlas space, unmodulated, not interpolated
disp('Resample mask')
job = struct();
job.subj.affineTr = {'Affine_c_t1_seg1.mat'};
job.subj.flowfield = {'u_a_c_t1_seg1.nii'};
job.subj.mask = {'c_t1_pcereb.nii'};
job.subj.resample = {'c_t1_pcereb.nii'};
job.interp = 0;
job.jactransf = 0;
suit_reslice_dartel(job);
movefile('wdc_t1_pcereb.nii','wc_t1_pcereb.nii');

% Create modulated grey and white matter images in atlas space
disp('Resample/modulate')
for m = {'c_t1_seg1.nii','c_t1_seg2.nii'}
	job = struct();
	job.subj.affineTr = {'Affine_c_t1_seg1.mat'};
	job.subj.flowfield = {'u_a_c_t1_seg1.nii'};
	job.subj.resample = m(1);
	job.subj.mask = {'c_t1_pcereb.nii'};
	job.interp = 1;
	job.jactransf = 1;
	suit_reslice_dartel(job);
end

% Resample the atlas to subject space
disp('Resample atlas')
job = struct();
job.Affine = {'Affine_c_t1_seg1.mat'};
job.flowfield = {'u_a_c_t1_seg1.nii'};
job.subj.mask = {'c_t1_pcereb.nii'};
job.resample = {[spm('dir') '/toolbox/suit/atlasesSUIT/Lobules-SUIT.nii']};
job.ref = {'c_t1.nii'};
job.interp = 0;
suit_reslice_dartel_inv(job);

% Copy atlas space atlas
disp('Copy atlas')
copyfile([spm('dir') '/toolbox/suit/atlasesSUIT/Lobules-SUIT.nii'],out_dir);

% Regional voxel counts and volumes in subject space. suit_vol does not
% compute the voxel volume correctly, so we use our own code.
disp('Regional volumes')
regional_volumes(out_dir)

% Clean up
organize_outputs(out_dir)
