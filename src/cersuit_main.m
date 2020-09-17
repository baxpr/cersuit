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

% First segmentation step of SUIT
suit_isolate_seg({'t1.nii'},'maskp',str2double(inp.maskp));

