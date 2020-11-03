function d=DistanceBtwFrames(x,y)
% function to calculate distance[mm/10] between frames
%
% d=DistanceBtwFrames(x,y)
%
% Input: array of x,y coordinates for animal
% Ouput: d, the distance[mm/10] between frames (pixels, me believes)
%
% JcSimon 10/12/2018

d=sqrt((x(1:end-1)-x(2:end)).^2+(y(1:end-1)-y(2:end)).^2); % Euclidean distance btw frames