function cersuit_main(inp)

% Copy input files to output dir
out_dir = inp.out_dir;
copyfile(inp.t1_niigz,fullfile(out_dir,'t1.nii.gz'))
copyfile(inp.gm_niigz,fullfile(out_dir,'gm.nii.gz'))

% Work in the output directory with unzipped .nii
cd(out_dir);
system('gunzip t1.nii.gz');
system('gunzip gm.nii.gz');

% Reorient the input file to meet SUIT requirement for axial data ordering
system(['FSLDIR=' inp.fsl_dir ' ' inp.src_dir '/initial_reorient.sh']);

% We need SPM running
spm_jobman('initcfg');

% Initial coreg of T1 to atlas via gray matter segmentation
coreg_txt = init_coreg_translation_only('gm.nii',out_dir);
apply_init_coreg(coreg_txt,'t1.nii',out_dir);

% Segment the cerebellum
suit_isolate_seg({'rt1.nii'},'maskp',str2double(inp.maskp),'keeptempfiles',1);

% Estimate the atlas space warp
disp('Estimate warp')
job = struct();
job.subjND(1).gray = {'c_rt1_seg1.nii'};
job.subjND(1).white = {'c_rt1_seg2.nii'};
job.subjND(1).isolation = {'c_rt1_pcereb.nii'};
suit_normalize_dartel(job);

% Create several images in SUIT atlas space, unmodulated, interpolated
disp('Resample images')
for m = {'c_rt1.nii','c_rt1_seg1.nii','c_rt1_seg2.nii'}
	job = struct();
	job.subj.affineTr = {'Affine_c_rt1_seg1.mat'};
	job.subj.flowfield = {'u_a_c_rt1_seg1.nii'};
	job.subj.mask = {'c_rt1_pcereb.nii'};
	job.subj.resample = m(1);
	job.interp = 1;
	job.jactransf = 0;
	suit_reslice_dartel(job);
	movefile(['wd' m{1}],['w' m{1}]);
end

% Create cer mask atlas space, unmodulated, not interpolated
disp('Resample mask')
job = struct();
job.subj.affineTr = {'Affine_c_rt1_seg1.mat'};
job.subj.flowfield = {'u_a_c_rt1_seg1.nii'};
job.subj.mask = {'c_rt1_pcereb.nii'};
job.subj.resample = {'c_rt1_pcereb.nii'};
job.interp = 0;
job.jactransf = 0;
suit_reslice_dartel(job);
movefile('wdc_rt1_pcereb.nii','wc_rt1_pcereb.nii');

% Create modulated grey and white matter images in atlas space
disp('Resample/modulate')
for m = {'c_rt1_seg1.nii','c_rt1_seg2.nii'}
	job = struct();
	job.subj.affineTr = {'Affine_c_rt1_seg1.mat'};
	job.subj.flowfield = {'u_a_c_rt1_seg1.nii'};
	job.subj.resample = m(1);
	job.subj.mask = {'c_rt1_pcereb.nii'};
	job.interp = 1;
	job.jactransf = 1;
	suit_reslice_dartel(job);
end

% Resample the atlas to subject space
disp('Resample atlases')
job = struct();
job.Affine = {'Affine_c_rt1_seg1.mat'};
job.flowfield = {'u_a_c_rt1_seg1.nii'};
job.subj.mask = {'c_rt1_pcereb.nii'};
job.ref = {'c_rt1.nii'};
job.interp = 0;
for m = {'Lobules-SUIT','Buckner_7Networks','Buckner_17Networks','Ji_10Networks','MDTB_10Regions'}
	job.resample = {[spm('dir') '/toolbox/suit/atlasesSUIT/' m{1} '.nii']};
	suit_reslice_dartel_inv(job);
	apply_reverse_coreg(coreg_txt,['iw_' m{1} '_u_a_c_rt1_seg1.nii']);
end

% Copy atlas space atlases
disp('Copy atlases')
for m = {'Lobules-SUIT','Buckner_7Networks','Buckner_17Networks','Ji_10Networks','MDTB_10Regions'}
	copyfile([spm('dir') '/toolbox/suit/atlasesSUIT/' m{1} '.nii'],out_dir);
end

% Get the native space output images back to pre-coreg native space
% (original T1 space). Header is updated in place.
for m = {'c_rt1','c_rt1_pcereb','c_rt1_seg1','c_rt1_seg2'}
	apply_reverse_coreg(coreg_txt,[m{1} '.nii']);
end

% Regional voxel counts and volumes in subject space. suit_vol does not
% compute the voxel volume correctly, so we use our own code.
disp('Regional volumes')
regional_volumes(out_dir)

% Make PDF
system([ ...
	'OUTDIR='   out_dir ' ' ...
	'FSLDIR='   inp.fsl_dir ' ' ...
	'IMMAGDIR=' inp.immag_dir ' ' ...
	'PROJECT='  inp.project ' ' ...
	'SUBJECT='  inp.subject ' ' ...
	'SESSION='  inp.session ' ' ...
	'SCAN='     inp.scan ' ' ...
	 inp.src_dir '/make_pdf.sh' ...
	]);

% Clean up
organize_outputs(out_dir)
