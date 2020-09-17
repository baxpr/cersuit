function cersuit(varargin)


%% Parse inputs
P = inputParser;

% T1 image (.nii.gz)
addOptional(P,'wt1_niigz','../INPUTS/wmt1.nii.gz');

% Smoothing to apply to connectivity maps
addOptional(P,'fwhm','6');

% Subject info if on XNAT
addOptional(P,'project','UNK_PROJ');
addOptional(P,'subject','UNK_SUBJ');
addOptional(P,'session','UNK_SESS');
addOptional(P,'scan','UNK_SCAN');

% Change paths to match test environment if needed
addOptional(P,'magick_path','/usr/bin');
addOptional(P,'src_path','/opt/mniconn/src');
addOptional(P,'fsl_path','/usr/local/fsl/bin');

% Where to store outputs
addOptional(P,'out_dir','../OUTPUTS');

% Parse
parse(P,varargin{:});
disp(P.Results)


%% Process
mniconn_main(P.Results);


%% Exit
if isdeployed
	exit
end

