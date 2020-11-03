function found=FindScoresFiles(directory,stringToBeFound1,stringToBeFound2,include_val)
% Function found=FindScoresFiles(directory,stringToBeFound1,stringToBeFound2,include_val)
%
% in:
% directory, Full path of the directory to be searched.
% stringToBeFound1, primary text string to find
% stringToBeFound2, secondary test string to narrow search +/- 
% include_val, 
% =1 excludes files including stringToBeFound2 (that is no, "Error" files)
% =-1 file names must include stringToBeFound2 (that is YES, "Error" files)
% =0 (or other) keeps full list, mostly for testing
%
% out: found, cell of files filtered by search word(s)
%
% JCSimon 8/13/2020

% Returns all the files and folders in the directory
filesAndFolders = dir(directory);

% Returns only the files in the directory
onlyFiles = filesAndFolders(~([filesAndFolders.isdir]));

% eliminate backup files with save names that include .mat~
for d=1:length(onlyFiles)
    % Store the name of the file
    filenametemp = onlyFiles(d).name;
    
    if isequal(strcmp('~', filenametemp(end)),1)
        onlyFiles(d).name='kill';
    end
end

foundBASE = cell(length(onlyFiles));

% loop through files
for i=1:length(onlyFiles)
    % Store the name of the file
    filename = onlyFiles(i).name;
    
    if isequal(strfind(filename,stringToBeFound1),1)
        % include in cell
        foundBASE{i}=filename;
    end
end

% remove any empty cells
foundBASE=foundBASE(~cellfun('isempty',foundBASE));


found = cell(length(foundBASE));
% include val to determine while files to select
if isequal(include_val,1)
    % if 1 select files with classified behaviour
    for j=1:size(foundBASE,1)
        if isequal(~contains(lower(foundBASE{j}),stringToBeFound2),1)
            % include in cell
            found{j}=foundBASE{j};
        else
            found{j}=[];
        end
    end
    if isequal(isempty([found{:}]),1)
        disp('String 2 is not in any of the file names.')
    end
elseif isequal(include_val,-1)
    % if -1 select files with suspicious behaviour
    for j=1:size(foundBASE,1)
        if isequal(~contains(lower(foundBASE{j}),stringToBeFound2),1)
            % include in cell
            found{j}=[];
        else
            found{j}=foundBASE{j};
        end
    end
    if isequal(isempty([found{:}]),1)
        disp('String 2 is not in any of the file names.')
    end
% keep all
else
    found=foundBASE;
end

% again remove any empty cells
found=found(~cellfun('isempty',found));
