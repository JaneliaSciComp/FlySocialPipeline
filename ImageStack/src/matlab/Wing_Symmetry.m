function [w1asym,w2asym,w_spread1,w_spread2]=Wing_Symmetry(trx)
% function to calculate the symmetry and
% spread for the wings of flies
%
% [w1asym,w2asym,w_spread1,w_spread2]=Wing_Symmetry(trx)
% 
% Input: trx variable
% Output:
% w1asym, absolute difference[degrees] btn left and right wings for fly 1
% w2asym, absolute difference[degrees] btn left and right wings for fly 2
% w_spread1, the angle[degrees] between left and right wings for fly 1
% w_spread3, the angle[degrees] between left and right wings for fly 2
%
% JCSimon 7/18/2018

% convert to degrees
w1l=trx(1).wing_anglel*180/pi;
w1r=trx(1).wing_angler*180/pi;
w2l=trx(2).wing_anglel*180/pi;
w2r=trx(2).wing_angler*180/pi;

% asymetry
w1asym=abs(w1l)-abs(w1r);
w2asym=abs(w2l)-abs(w2r);

% spread
w_spread1=abs(w1r)+abs(w1l);
w_spread2=abs(w2r)+abs(w2l);