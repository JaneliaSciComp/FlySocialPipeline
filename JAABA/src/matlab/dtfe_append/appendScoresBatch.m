function appendScoresBatch(parentDir,error_val)
%
% Function to identify experimental folders
% and then append error or score files as
% fields to trx structure array.
%
% in:
% parentDir, directory path to experimental folder
% error_val, =-1 means error scores files =1 (other)
% true classified behaviors scores files.
%
% out: saves see appendScores function
%
% uses:
% subFolders(parentDir)
% appendScores(parentDir,error_val)

% identify subfolders (experimental folders)
% within parent folder
F=subFolders(parentDir);

for chug=1:size(F,2)
    expDir=sprintf('%s/%s', parentDir, F{chug});
    appendScores(expDir, error_val)
end