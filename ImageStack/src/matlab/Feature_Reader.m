function trx=Feature_Reader(data_path)
% function to load and extract per-frame features from 
% .mat that contains trx data structure (Ctrax or DuoTrax)
%
% first step in a suite of functions to work with feature
% data.
%
% trx=FeatureReader(data_path)
%
% Input: file path to .MAT data
% Ouput: trx variable
% 
% JCSimon 7/18/2018
load(data_path)