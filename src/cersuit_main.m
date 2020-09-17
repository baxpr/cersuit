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
job = struct();
job.subjND(1).gray = {'c_t1_seg1.nii'};
job.subjND(1).white = {'c_t1_seg2.nii'};
job.subjND(1).isolation = {'c_t1_pcereb.nii'};
suit_normalize_dartel(job);

% Create T1 image in atlas space
job = struct();
job.subj.affineTr = {'Affine_c_t1_seg1.mat'};
job.subj.flowfield = {'u_a_c_t1_seg1.nii'};
job.subj.resample = {'t1.nii'};
job.subj.mask = {'c_t1_pcereb.nii'};
job.interp = 1;
job.jactransf = 0;
suit_reslice_dartel(job);

% Create modulated grey matter image in atlas space
job = struct();
job.subj.affineTr = {'Affine_c_t1_seg1.mat'};
job.subj.flowfield = {'u_a_c_t1_seg1.nii'};
job.subj.resample = {'c_t1_seg1.nii'};
job.subj.mask = {'c_t1_pcereb.nii'};
job.interp = 1;
job.jactransf = 1;
suit_reslice_dartel(job);

% Resample the atlas to subject space
job = struct();
job.Affine = {'Affine_c_t1_seg1.mat'};
job.flowfield = {'u_a_c_t1_seg1.nii'};
job.resample = {[spm('dir') '/toolbox/suit/atlasesSUIT/Lobules-SUIT.nii']};
job.ref = {'t1.nii'};
job.interp = 0;
suit_reslice_dartel_inv(job);

% Regional voxel counts and volumes in subject space. suit_vol does not
% compute the voxel volume correctly, so we use our own code.
regional_volumes(out_dir)

