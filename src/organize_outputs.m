function organize_outputs(out_dir)

cd(out_dir);
delete('t1.nii');
delete('t1_seg8.mat');
delete('c1t1.nii');
delete('c2t1.nii');
delete('c7t1.nii');
delete('c8t1.nii');
delete('y_t1.nii');
system('gzip *.nii');
