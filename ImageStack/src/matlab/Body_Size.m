function [r1,r2,l1,w1,l2,w2]=Body_Size(trx, adjust)
% function to extract length, width, 
% and length/width ratio for flies
% 
% [r1,r2,l1,w1,l2,w2]=Body_Size(trx, adjust)
% 
% Input: trx variable, adjust, from frame calibration
% Ouputs: 
% r1,r2 l/w ratios for fly 1 and fly2
% l1,w1 length and width for fly 1
% l2,w2 length and width for fly 2
%
% JCSimon 7/18/2018

% length and width
l1=(trx(1).a_mm.*4).*adjust; w1=(trx(1).b_mm.*4).*adjust; % Kristin said that "quarter major/minor" is a bug in Ctrax code and thus real length should be x4
l2=(trx(2).a_mm.*4).*adjust; w2=(trx(2).b_mm.*4).*adjust;

% length / width ratios
r1=l1./w1; % fly 1
r2=l2./w2; % fly 2