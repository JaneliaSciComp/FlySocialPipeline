function frames=stringvalueExtract_xml(filename_dir)
% Function to find value associated with string
% .xml file
%
% frames=stringvalueExtract_xml(filename_dir)
%
% input:
% filename_dir, directory path to configuration .xml file containing 
%  metadata from Tracking output including total number of frames in movie.
%
% output:
% frames, total number of frames in movie.
%
% JCSimon 9/23/2020

xmlframes = xml2struct(filename_dir);

% make variable for init
frames_string = xmlframes.params.track.Attributes.lastframetrack;
frames=str2double(frames_string); % convert string to number
