function d=DistanceBtwFlies(x1,y1,x2,y2)
% function to calculate distance[mm/10] between flies
%
% d=DistanceBtwFlies(x1,y1,x2,y2)
%
% in: x,y for each of the flies
%
% Ouput: d, the distance[mm] between fies (pixels, me believes)
%
% JcSimon 10/12/2018

d=sqrt((x1-x2).^2+(y1-y2).^2); % Euclidean distance btw flies
