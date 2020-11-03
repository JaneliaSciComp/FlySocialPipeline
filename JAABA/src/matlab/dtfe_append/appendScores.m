function appendScores(directory, error_val)
%function: appendScores(directory,error_val)
%
% script appends likely error arrays to registered_trx
%
% in:
% directory, directory path to experimental folder
% error_val, =-1 means error scores files =1 (other)
% true classified behaviors scores files.
%
% out: na
%
% saves: .mat file for DTFE and final analysis steps
% That is, registered_trxPossibleErrorsIndices.mat
% and, registered_trxClassifiedBehaviors.mat
%
% requires:
% FindScoresFiles
%
% JCSimon 7/24/2017
% JCSimon 8/11/2017
% JCSimon 9/5/2017
% JCsimon 8/14/2020

% switches between alternative uses: =1 scores files for classified behaviors; =-1 scores
% files for classified likely errors
% hard coded:
stringToBeFound1='scores';
stringToBeFound2='error'; % String is required in name to be identified as "Error" scores file.

if ischar(error_val)
    error_val = str2double(error_val);
end

% FindScoresFiles generates cell of file names
found=FindScoresFiles(directory,stringToBeFound1,stringToBeFound2,error_val);

% append suspicious errors fields from scores files to trx variable
for batch_var=1:size(found,1)
    
    % load scores file
    load_val1=sprintf('%s/%s', directory, found{batch_var});
    load(load_val1);
    
    % extract array with 1 = where error needs to be checked
    Behavior1=allScores.postprocessed{1}; Behavior1(1)=1; % sets first element of array to 1
    Behavior2=allScores.postprocessed{2}; Behavior2(1)=1;
    
    % load DuoTrax OUTPUT
    if isequal(batch_var,1)
        load_val2=sprintf('%s/%s', directory,'registered_trx.mat');
        load(load_val2);
    else
        if isequal(error_val,1)
            load_val2=sprintf('%s/%s', directory,'registered_trxClassifiedBehaviors.mat');
            load(load_val2);
        else
            load_val2=sprintf('%s/%s', directory,'registered_trxPossibleErrorsIndices.mat');
            load(load_val2);
        end
    end
    
    % name error struct
    % split string
    newStr=split(found{batch_var},'_');
    if isequal(error_val,-1)
        % for names that include error, as in scores_error_typingfast
        newStr=[newStr{3:end}]; newStr=newStr(1:end-4);
        name_val=sprintf('%s', newStr);
         
        % append error logical array as a field of trx (JCSimon 8/26/2020)
        error_name=sprintf('susp%s',name_val);
        trx(1).(error_name)=Behavior1;
        trx(2).(error_name)=Behavior2;
        
        % for names that include only behavior, as in scores_giggle
    else
        newStr=[newStr{2:end}]; newStr=newStr(1:end-4);
        name_val=sprintf('%s', newStr);
        
        % append error logical array as a field of trx
        scores_name=sprintf('classifiedbehavior_%s',name_val);
        trx(1).(scores_name)=Behavior1;
        trx(2).(scores_name)=Behavior2;
        
    end
    
    % clear variable for specificed saving below doesn't seems to work
    clear Behavior1;
    clear Behavior2;
    clear name_val;
    clear allScores;
    clear behaviorName;
    clear jabFileNameAbs;
    clear timestamp;
    clear version;
    
    if isequal(error_val,-1)
        save_val=sprintf('%s/%s',directory,'registered_trxPossibleErrorsIndices.mat');
        save(save_val,'trx','timestamps');
        % save temp file
        %%%%%save('registered_trxWsuspID.mat','trx','timestamps');
        % % % % % % % % % % % %
        % save('registered_trxWsuspIDandOrt.mat','trx','timestamps'); <-- to
        % work with DTFE, currently
    else
        save_val=sprintf('%s/%s',directory,'registered_trxClassifiedBehaviors.mat');
        save(save_val,'trx','timestamps');
    end
end
