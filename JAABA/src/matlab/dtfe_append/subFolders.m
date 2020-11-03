function folders = subFolders(parentDir)
% 
% function [subDirsNames] = subFolders(parentDir)
%
% JCSimon 8/26/2020

% Get a list of all files and folders in parent folder.
files    = dir(parentDir);
names    = {files.name};

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');

% Extract only those that are directories.
folders = names(dirFlags);