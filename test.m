lines          = importdata('MapPoints_3D.txt');
pts_w3d         = lines(:, 1:3);
normals        = lines(:, 4:6);
psMaxDistance  = lines(:, 7);
psMinDistance  = lines(:, 8);

cameraParams  = [585 , 0  , 320 ;
                0   , 585 , 240 ;
                0   , 0   , 1   ];
            
orb_RT_path = '/home/linux/Downloads/ORB_SLAM2-master/Trajectory/';
for seq_idx = 1 : 6
    orb_RT_list = dir(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), '*.pose.txt'));
    n_img       = length(orb_RT_list);
    
    RT_ORB  = importdata(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), orb_RT_list.name));
    rcw     = RT_ORB(1:3, 1:3);
    tcw     = RT_ORB(1:3, 4);
    pts_c3d  = (rcw * pts_w3d' + tcw)';
    pts_c2d  = Project3D(RT_ORB, cameraParams, pts_w3d);

    isInFrustum(pts_c3d, pts_c2d, tcw', 0.5, normals, psMaxDistance, psMinDistance);
end