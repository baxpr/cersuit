function  transform_SUIT_to_native(varargin)

%% Parse inputs
P = inputParser;

% Image that will be transformed from the SUIT atlas space to the original
% native T1 space
addOptional(P,'src_nii','../OUTPUTS/wc_rt1_test.nii');

% Mask in the original native space
addOptional(P,'mask_nii','../OUTPUTS/c_rt1_pcereb.nii');

% Initial rigid body coregistration of T1 to atlas (RIGID output of
% cersuit)
addOptional(P,'coreg_txt','../OUTPUTS/init_coreg_mat.txt');

% SUIT affine transform (AFFINE)
addOptional(P,'affine_mat','../OUTPUTS/Affine_c_rt1_seg1.mat');

% SUIT deformation/flowfield (FLOWFIELD)
addOptional(P,'flow_nii','../OUTPUTS/u_a_c_rt1_seg1.nii');

% Interpolation to use
addOptional(P,'interp','0');

% Where to store outputs
addOptional(P,'out_dir','../OUTPUTS');


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


%% Do the actual transformation

job = struct();
job.Affine = {P.Results.affine_mat};
job.flowfield = {P.Results.flow_nii};
job.subj.mask = {P.Results.mask_nii};
job.ref = {P.Results.src_nii};
job.interp = interp;
job.resample = {P.Results.src_nii};
suit_reslice_dartel_inv(job);

[ps,ns] = fileparts(P.Results.src_nii);
[~,nf] = fileparts(P.Results.flow_nii);
suit_out_fname = fullfile(ps,['iw_' ns '_' nf '.nii']);

apply_reverse_coreg(P.Results.coreg_txt,suit_out_fname);

if ~strcmp(ps,P.Results.out_dir)
	movefile(suit_out_fname,P.Results.out_dir);
end


