function transform_native_to_SUIT(varargin)

%% Parse inputs
P = inputParser;

% Image that will be transformed from the original T1 space to the SUIT
% atlas space
addOptional(P,'src_niigz','../OUTPUTS/testt1.nii.gz');

% Mask in the same space as the source image
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

% Modulate by Jacobian ('1') or not ('0')
addOptional(P,'jactransf','0');

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
if ~isnumeric(P.Results.jactransf)
	jactransf = str2double(P.Results.jactransf);
else
	jactransf = P.Results.jactransf;
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

% First the initial coreg for source image and mask. Mask assumed to be in
% the same space as the source image.
rsrc_nii = apply_init_coreg(P.Results.coreg_txt,src_nii,P.Results.out_dir);
rmask_nii = apply_init_coreg(P.Results.coreg_txt,mask_nii,P.Results.out_dir);

% Then the SUIT affine+warp
job = struct();
job.subj.affineTr = {P.Results.affine_mat};
job.subj.flowfield = {flow_nii};
job.subj.mask = {rmask_nii};
job.subj.resample = {rsrc_nii};
job.interp = interp;
job.jactransf = jactransf;
suit_reslice_dartel(job);


%% Clean up
delete(src_nii)
delete(mask_nii)
delete(flow_nii)
delete(rsrc_nii)
delete(rmask_nii)
system(['gzip ' P.Results.out_dir '/*.nii']);

if isdeployed
	exit
end


