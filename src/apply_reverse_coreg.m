function apply_reverse_coreg(mat_file,img_file)

% Rigid body transform from approximate alignment with template, back to
% original native space and position

mat = load(mat_file);
V = spm_vol(img_file);
Y = spm_read_vols(V);
V.mat = mat \ V.mat;
spm_write_vol(V,Y);
