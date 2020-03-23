clc;
clear;
close all;
dbstop if error;

img_path    = '/home/lionky/SLAMDataset/7Scenes/chess/';
orb_RT_path = '/home/lionky/Desktop/Visual_SLAM/SOTAs/geomapnet-master/results/pred_poses/';
cameraParams  = [585 , 0  , 320 ;
                0   , 585 , 240 ;
                0   , 0   , 1   ];
for seq_idx = 3 : 3
    RT_list     = dir(fullfile(img_path, num2str(seq_idx, 'seq-%02d'), '*.pose.txt'));
    orb_RT_list = dir(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), '*.pose.txt'));
    n_img       = length(RT_list);
    
    figure(1); clf;
    orb_index = 1;
    for i_img = 1 : n_img
        RT      = importdata(fullfile(img_path, num2str(seq_idx, 'seq-%02d'), RT_list(i_img).name));
        % both geomapnet and dataset's RT are RTwc, thus is the camera trajectory
        R_gt = RT(1:3, 1:3);
        T_gt = RT(1:3, 4);
        
        names = orb_RT_list(orb_index).name(7:12);
        num = str2double(names) + 1;
        if i_img == num
            RT_ORB  = importdata(fullfile(orb_RT_path, num2str(seq_idx, 'seq-%02d'), orb_RT_list(orb_index).name));
            R_ORB = RT_ORB(1:3, 1:3);
            T_ORB = RT_ORB(1:3, 4);
            
            figure(1); clf;
            subplot(1, 2, 1);
            location =  -R_gt' * T_gt;   % 1 * 3
            xlim([-2,4]);
            ylim([-5,2]);
            hold on;
            plotCamera('Location',location,'Orientation',R_gt,'Opacity',0);
            hold off;
            
            subplot(1, 2, 2);
            location =  -R_ORB' * T_ORB;   % 1 * 3
            xlim([-2,4]);
            ylim([-5,2]);
            hold on;
            plotCamera('Location',location,'Orientation',R_ORB,'Opacity',0);
            hold off;
            orb_index = orb_index + 1;
        else
            figure(1); clf;
            subplot(1, 2, 1);
            xlim([-2,4]);
            ylim([-5,2]);
            hold on;
            plotCamera('Location',T_gt,'Orientation',R_gt,'Opacity',0);
            hold off;
        end
        pause(0.03);
    end
end
