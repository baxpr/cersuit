function regional_volumes(out_dir)

% Load atlas labels, assuming the Lobules-SUIT atlas
copyfile([spm('dir') '/toolbox/suit/atlasesSUIT/Lobules-SUIT.nii.lut'] ,...
	[out_dir '/iw_Lobules-SUIT-lut.txt']);
labels = readtable([out_dir '/iw_Lobules-SUIT-lut.txt'], ...
	'Delimiter','space','ReadVariableNames',false);
labels = labels(:,{'Var1','Var8'});
labels.Properties.VariableNames = {'Label','Region'};

% Compute volumes for each label
Vseg = spm_vol([out_dir '/iw_Lobules-SUIT_u_a_c_rt1_seg1.nii']);
seg = spm_read_vols(Vseg);
Vgm = spm_vol([out_dir '/c_rt1_seg1.nii']);
gm = spm_read_vols(Vgm);
Vwm = spm_vol([out_dir '/c_rt1_seg2.nii']);
wm = spm_read_vols(Vwm);
voxvol = abs(det(Vseg.mat(1:3,1:3)));
for k = 1:height(labels)
	labels.Total_Voxels(k,1) = sum(seg(:)==labels.Label(k));
	labels.Total_Volume_mm3(k,1) = round(voxvol*labels.Total_Voxels(k,1), 3);
	labels.Gray_Voxels(k,1) = sum(gm(seg(:)==labels.Label(k)));
	labels.Gray_Volume_mm3(k,1) = round(voxvol*labels.Gray_Voxels(k,1), 3);
	labels.Gray_Voxels(k,1) = round(labels.Gray_Voxels(k,1),3);
	labels.White_Voxels(k,1) = sum(wm(seg(:)==labels.Label(k)));
	labels.White_Volume_mm3(k,1) = round(voxvol*labels.White_Voxels(k,1), 3);
	labels.White_Voxels(k,1) = round(labels.White_Voxels(k,1),3);
end

% Store labels and volumes to file
writetable(labels,[out_dir '/iw_Lobules-SUIT_u_a_c_rt1_seg1-volumes.csv']);

