clear all;
close all;
clc;

file_path = '/groups/heberlein/heberleinlab/Simon/DeepLearningData_SherrySet/';

data = importdata([file_path, 'DeepLearnVolumesheberleinlabSimonSherrySetM4-85_4-85_p02.mat']);

cell1 = data{1};
disp("1st video array size:");
disp(size(cell1.video_cropSTACK));
cell2 = data{2};
disp("2nd video array size:");
disp(size(cell2.video_cropSTACK));

figure;
hold on;
% subplot(2,2,1)
% imshow(cell1.video_cropSTACK(:,:,95));
% subplot(2,2,2)
% imshow(cell1.video_cropSTACK(:,:,135));
% subplot(2,2,3)
% imshow(cell2.video_cropSTACK(:,:,152));
% subplot(2,2,4)
% imshow(cell2.video_cropSTACK(:,:,208));
% hold off;

for i = 1:16
    subplot(4,4,i)
    imshow(cell2.video_cropSTACK(:,:,i+390));
end