function regional_volumes(out_dir)

% Load atlas labels, assuming the Lobules-SUIT atlas
copyfile([spm('dir') '/toolbox/suit/atlasesSUIT/Lobules-SUIT.nii.lut'] ,...
	[out_dir '/iw_Lobules-SUIT-lut.txt']);
labels = readtable([out_dir '/iw_Lobules-SUIT-lut.txt'], ...
	'Delimiter','space','ReadVariableNames',false);
labels = labels(:,{'Var1','Var8'});
labels.Properties.VariableNames = {'Label','Region'};

% Compute volumes for each label
V = spm_vol([out_dir '/iw_Lobules-SUIT_u_a_c_t1_seg1.nii']);
voxvol = abs(det(V.mat(1:3,1:3)));
Y = spm_read_vols(V);
for k = 1:height(labels)
	labels.Voxels(k,1) = sum(Y(:)==labels.Label(k));
	labels.Volume_mm3(k,1) = round(voxvol * labels.Voxels(k,1), 3);
end

% Store labels and volumes to file
writetable(labels,[out_dir '/iw_Lobules-SUIT_u_a_c_t1_seg1-volumes.csv']);

