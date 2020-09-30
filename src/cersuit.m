function cersuit(varargin)


%% Parse inputs
P = inputParser;

% T1 image (.nii.gz)
addOptional(P,'t1_niigz','../INPUTS/t1.nii.gz');

% Native space gray matter segmentation of the T1 image
addOptional(P,'gm_niigz','../INPUTS/gm.nii.gz');

% Masking threshold for suit_isolate_seg
addOptional(P,'maskp','0.2');

% Subject info if on XNAT
addOptional(P,'project','UNK_PROJ');
addOptional(P,'subject','UNK_SUBJ');
addOptional(P,'session','UNK_SESS');
addOptional(P,'scan','UNK_SCAN');

% Change paths to match test environment if needed
addOptional(P,'fsl_dir','/usr/local/fsl');
addOptional(P,'src_dir','/opt/cersuit/src');
addOptional(P,'immag_dir','/usr/bin');

% Where to store outputs
addOptional(P,'out_dir','../OUTPUTS');

% Parse
parse(P,varargin{:});
disp(P.Results)


%% Process
cersuit_main(P.Results);


%% Exit
if isdeployed
	exit
end

