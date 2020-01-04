close all;
clear;
clf;
clc;

lines           = importdata('MapPoints_3D.txt');
pick            = find(any(lines(:, 1:2) <= -3, 2));
lines(pick, :)  = [];
pts_w3d         = lines(:, 1:3);
normals         = lines(:, 4:6);
psMaxDistance   = lines(:, 7);
psMinDistance   = lines(:, 8);



cameraParams  = [585 , 0  , 320 ;
                0   , 585 , 240 ;
                0   , 0   , 1   ];

% 平均观测法向量是怎么得到的
% scatter3(pts_w3d(:, 1), pts_w3d(:, 2), pts_w3d(:, 2));
orb_RT_path = '/home/linux/Downloads/ORB_SLAM2-master/Trajectory/';
img_path    = '/home/linux/SLAMDataset/7Scenes/chess/';
for seq_idx = 3 : 3
    orb_RT_list = dir(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), '*.pose.txt'));
    n_img       = length(orb_RT_list);
    for i = 1 : n_img
        RT_ORB  = importdata(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), orb_RT_list(i).name));
        rcw     = RT_ORB(1:3, 1:3);
        tcw     = RT_ORB(1:3, 4);
        location =  -tcw' * rcw;    % 1 * 3
        pts_c3d  = (rcw * pts_w3d' + tcw)';
        pts_c2d  = Project3D(RT_ORB, cameraParams, pts_w3d);
        
        isVisible = isInFrustum(pts_w3d, pts_c3d, pts_c2d, location, 0.5, normals, psMaxDistance, psMinDistance);
        
        img_name = strrep(orb_RT_list(i).name, '.pose.txt', '.color.png');
        img     = imread(fullfile(img_path, num2str(seq_idx, 'seq-%02d'), img_name));
        
        figure(1);
        imshow(img);
        hold on;
        plot(pts_c2d(:, 1), pts_c2d(:, 2), '*r');
        hold off;
        figure(2);
        imshow(img);
        hold on;
        plot(pts_c2d(isVisible==1, 1), pts_c2d(isVisible==1, 2), '*b');
        hold off;
        figure(3);
        pcshow(pts_w3d);
        hold on;
        plot3(pts_w3d(~logical(isVisible), 1), pts_w3d(~logical(isVisible), 2) , pts_w3d(~logical(isVisible), 3), '.r');
        plot3(pts_w3d(logical(isVisible), 1), pts_w3d(logical(isVisible), 2) , pts_w3d(logical(isVisible), 3), '.b');
        plotCamera('Location', location, 'Orientation', rcw,'Opacity',0, 'Size',0.05);
        hold off;
        
        pause(0.03);
    end
end