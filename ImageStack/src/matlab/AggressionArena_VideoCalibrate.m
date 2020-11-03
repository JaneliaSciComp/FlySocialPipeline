function [pixel_length, adjust]=AggressionArena_VideoCalibrate(videoFrames, knownlength,gui_val,pixel_length)
% Function that uses ginput to calibrate the size
% of a arena used to study social behavior.
% move mouse over 2 known points and press spacebar
% 
% [pixel_length, adjust]=AggressionArenaVideoCalibrate(videoFrames, knownlength,gui_val,pixel_length)
%
% Input: 
% movie, nxm image
% knownlendth, length in mm between two point in video frame
%
% Output:
% pixel_length, distance between two point clicked with ginput
% adjust, value to adjust data
%
% JCSimon 7/20/2018

if isequal(gui_val,1) % allows specific and collective measurements
    % figure
    figure('Position', [500 500 500 500]);
    imshow(videoFrames(:,:,1));
    
    disp('Click on two points and then press space bar.')
    
    % data from GUI
    [x(1),y(1)]=ginput(1); % two point from image
    hold
    plot(x,y, 'xg');
    [x(2),y(2)]=ginput(1); % two point from image
    plot(x,y, 'xg');
    
    % calculate pixel length
    pixel_length=sqrt(((x(1)-x(2)).^2)+((y(1)-y(2)).^2)); % Pythagorean distance between inputs
    
    pause
    close
end

% calculate amount to adjust other objects in movie
adjust=knownlength/pixel_length;

