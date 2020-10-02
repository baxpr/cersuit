function  transform_SUIT_to_native(varargin)

%% Parse inputs
P = inputParser;

% Image that will be transformed from the SUIT atlas space to the original
% native T1 space
addOptional(P,'src_niigz','../OUTPUTS/MNI152_T1_1mm.nii.gz');

% Mask in the original native space. Also determines the geometry of the
% output
addOptional(P,'mask_niigz','../OUTPUTS/c_rt1_pcereb.nii.gz');

% Initial rigid body coregistration of T1 to atlas (RIGID output of
% cersuit)
addOptional(P,'coreg_txt','../OUTPUTS/init_coreg_mat.txt');

% SUIT affine transform (AFFINE)
addOptional(P,'affine_mat','../OUTPUTS/Affine_c_rt1_seg1.mat');

% SUIT deformation/flowfield (FLOWFIELD)
addOptional(P,'flow_niigz','../OUTPUTS/u_a_c_rt1_seg1.nii.gz');

% Interpolation to use
addOptional(P,'interp','0');

% Where to store outputs
addOptional(P,'out_dir','../OUTPUTS2');


% Parse
parse(P,varargin{:});

% Fix a couple params to be numeric
if ~isnumeric(P.Results.interp)
	interp = str2double(P.Results.interp);
else
	interp = P.Results.interp;
end

% Take a look
disp(P.Results)


%% Copy/unzip nii.gz
copyfile(P.Results.src_niigz,P.Results.out_dir);
[~,n,e] = fileparts(P.Results.src_niigz);
system(['gunzip ' fullfile(P.Results.out_dir,[n e])]);
src_nii = fullfile(P.Results.out_dir,n);

copyfile(P.Results.mask_niigz,P.Results.out_dir);
[~,n,e] = fileparts(P.Results.mask_niigz);
system(['gunzip ' fullfile(P.Results.out_dir,[n e])]);
mask_nii = fullfile(P.Results.out_dir,n);

copyfile(P.Results.flow_niigz,P.Results.out_dir);
[~,n,e] = fileparts(P.Results.flow_niigz);
system(['gunzip ' fullfile(P.Results.out_dir,[n e])]);
flow_nii = fullfile(P.Results.out_dir,n);


%% Do the actual transformation

% First we need the mask in the intermediate coreg space to serve as our
% geometry ref
rmask_nii = apply_init_coreg(P.Results.coreg_txt,mask_nii,P.Results.out_dir);

job = struct();
job.Affine = {P.Results.affine_mat};
job.flowfield = {flow_nii};
job.subj.mask = {rmask_nii};
job.ref = {rmask_nii};
job.interp = interp;
job.resample = {src_nii};
suit_reslice_dartel_inv(job);

[ps,ns] = fileparts(src_nii);
[~,nf] = fileparts(flow_nii);
suit_out_fname = fullfile(ps,['iw_' ns '_' nf '.nii']);

apply_reverse_coreg(P.Results.coreg_txt,suit_out_fname);


%% Clean up
delete(src_nii)
delete(mask_nii)
delete(rmask_nii)
delete(flow_nii)
system(['gzip ' P.Results.out_dir '/*.nii']);

if isdeployed
	exit
end

