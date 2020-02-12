clc;
clear;
close all;
dbstop if error;

pt_3d       = importdata('MapPoints_3D.txt');
img_path    = '/home/linux/SLAMDataset/7Scenes/chess/';
orb_RT_path = '/home/linux/Downloads/ORB_SLAM2-master/Trajectory/';
cameraParams  = [585 , 0  , 320 ;
                0   , 585 , 240 ;
                0   , 0   , 1   ];
pt_3d_MXS   = load('chess_seq-points.mat');
pt_3d_MXS   = pt_3d_MXS.mappoints(:, 2:end);

for seq_idx = 1 : 6
    disp(seq_idx);
    
    img_list    = dir(fullfile(img_path, num2str(seq_idx, 'seq-%02d'), '*.color.png'));
    RT_list     = dir(fullfile(img_path, num2str(seq_idx, 'seq-%02d'), '*.pose.txt'));
    n_img       = length(img_list);
    
    orb_RT_list = dir(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), '*.pose.txt'));    
    
    figure(1); clf;
    orb_index = 1;
    for i_img = 1 : n_img
        img     = imread(fullfile(img_path, num2str(seq_idx, 'seq-%02d'), img_list(i_img).name));
        RT      = importdata(fullfile(img_path, num2str(seq_idx, 'seq-%02d'), RT_list(i_img).name));
        pt_2d_gt    = Project3D(PoseInv(RT), cameraParams, pt_3d_MXS);
        % PoseInv是求逆，但是旋转矩阵是正交矩阵，因此求逆和求转置的结果一样，但是实际数值并不一定完美正交，所以二者（求逆、转置）会有一点微小的差异
        
        names = orb_RT_list(orb_index).name(7:12);
        num = str2double(names) + 1;
        if i_img == num
            RT_ORB  = importdata(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), orb_RT_list(orb_index).name));
            pt_2d_ORB   = Project3D(RT_ORB, cameraParams, pt_3d);
            
            figure(1); clf;
            
            subplot(1, 2, 1);
            imshow(img);
            hold on;
            plot(pt_2d_gt(:, 1), pt_2d_gt(:, 2), '*r');
            hold off;
            
            subplot(1, 2, 2);
            imshow(img);
            hold on;
            plot(pt_2d_ORB(:, 1), pt_2d_ORB(:, 2), '*r');
            hold off;
            orb_index = orb_index + 1;
        else
            imshow(img);
            hold on;
            plot(pt_2d_gt(:, 1), pt_2d_gt(:, 2), '*r');
            hold off;            
        end
        pause(0.03);
    end
end
