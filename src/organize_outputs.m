function organize_outputs(out_dir)

cd(out_dir);

system('gzip *.nii');

mkdir('ATLASES_NATIVE')
movefile('iw_Buckner_17Networks_u_a_c_rt1_seg1.nii.gz','ATLASES_NATIVE');
movefile('iw_Buckner_7Networks_u_a_c_rt1_seg1.nii.gz','ATLASES_NATIVE');
movefile('iw_Ji_10Networks_u_a_c_rt1_seg1.nii.gz','ATLASES_NATIVE');
movefile('iw_Lobules-SUIT_u_a_c_rt1_seg1.nii.gz','ATLASES_NATIVE');
movefile('iw_MDTB_10Regions_u_a_c_rt1_seg1.nii.gz','ATLASES_NATIVE');

mkdir('ATLASES_SUIT')
movefile('Buckner_17Networks.nii.gz','ATLASES_SUIT');
movefile('Buckner_7Networks.nii.gz','ATLASES_SUIT');
movefile('Ji_10Networks.nii.gz','ATLASES_SUIT');
movefile('Lobules-SUIT.nii.gz','ATLASES_SUIT');
movefile('MDTB_10Regions.nii.gz','ATLASES_SUIT');
