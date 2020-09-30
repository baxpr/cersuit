function cimg_file = apply_init_coreg(mat_file,img_file,out_dir)

mat = load(mat_file);
[~,n,e] = fileparts(img_file);
V = spm_vol(img_file);
Y = spm_read_vols(V);
V.mat = mat * V.mat;
cimg_file = [out_dir '/r' n e];
V.fname = cimg_file;
spm_write_vol(V,Y);
