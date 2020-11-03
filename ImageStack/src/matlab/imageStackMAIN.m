function imageStackMAIN(filedir,filt_val,Trackconfig_file,VGGconfig_file)
%Function (MAIN) for identifying, and if flagged, filtering
% which frames to extract for establishing the ID of flies from pairs based 
% on wing clipping status using VGG model.
%
% imageStackMAIN(filedir,filt_val,VGGconfig_file,Trackconfig_file)
%
% inputs:
% filedir, directory path to experimental folder containing movie, trx files.
% filt_val, ~=1 extracts full image stack; if =1 then filters stack with
%  configured values used to build VGG model, or other values (via 
%  VGGconfig_file).
% Trackconfig_file, directory path to config .xml file that contains the total 
%  number of frames in movie (e.g., 20 minutes = 36000 @ 30fps)
%  currently: /Volumes/heberleinlab/Simon/Code/ConfigFiles/Clstr3R_params.xml
% VGGconfig_file, directory path to config .txt file that contains the filter 
%  values for VGG. This is only needed if filt_val = 1
%  currently: /Volumes/heberleinlab/Simon/Code/ConfigFiles/deepID_values.txt
%
% outputs:
% None. However utilized ImageStack.m function saves imageStackout.mat file
% containing the structure variable "deep", stacks of images for the pair of 
% flies and associated meta data for deepID (VGG model) module. Note deep{5} 
% is the Euclidean distance between flies among each frame and might be 
% useful as a filter for which frames to be used in deepID classifier.
%
% uses:
% config_Stack.m
% ImageStack.m
%
% JCSimon 9/18/2020

% extract frames from .xml file
frames=stringvalueExtract_xml(Trackconfig_file);

% switch between filtered and full stacks
if isequal(filt_val, '1') || isequal(filt_val, 'true') || isequal(filt_val, 1)
    frames_out=config_Stack(filedir, VGGconfig_file, frames);
    ImageStack(filedir, frames_out);
else
    frames_out{1}=1:frames;
    frames_out{2}=1:frames;
    ImageStack(filedir, frames_out);
end