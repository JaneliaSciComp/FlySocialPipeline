function [d1,d2,x_orgn,y_orgn]=Distance_FromWall(x1,y1,x2,y2)
% function that calculates distance[mm] of flies from wall
%
% [d1,d2,x_orgn,y_orgn]=Distance_FromWall(x1,y1,x2,y2)
%
% Input: x,y coordinates for flies
% Output: 
% d1,d2 distance[mm] for to flies from wall over time
% x_orgn, y_orgn the x,y coordinates for center of arean
%
% JCSimon 7/18/2018

% find max and min
% x
max_x=max([x1 x2]);
min_x=min([x1 x2]);

%y
max_y=max([y1 y2]);
min_y=min([y1 y2]);

% origin
x_orgn=((max_x-min_x)/2)+min_x;
y_orgn=((max_y-min_y)/2)+min_y;

% distances from origin
d1=sqrt(((x1-x_orgn).^2)+((y1-y_orgn).^2)); % Pythagorean distance fly 1
d2=sqrt(((x2-x_orgn).^2)+((y2-y_orgn).^2)); % Pythagorean distance fly 2