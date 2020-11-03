function [x1,y1,x2,y2,x1p,y1p,x2p,y2p]= XY_Flies(trx, adjust)
% function to extract x,y coordinate for flies
%
% [x1,y1,x2,y2,x1p,y1p,x2p,y2p]= XYFlies(trx, adjust)
% 
% Input: trx variable, adjust from frame calibration
% Output: 
% x1,y1 coordinates[mm] of fly 1 over time
% x2,y2 coordinates[mm] of fly 2 over time
% x1p,y1p coordinates[pixels] of fly 1 over time
% x2p,y2p coordinates[pixels] of fly 2 over time
%
% JCSimon 7/18/2018

% real size
x1=(trx(1).x_mm).*adjust; y1=(trx(1).y_mm).*adjust;
x2=(trx(2).x_mm).*adjust; y2=(trx(2).y_mm).*adjust;

% pixel size
x1p=trx(1).x_mm; y1p=trx(1).y_mm;
x2p=trx(2).x_mm; y2p=trx(2).y_mm;