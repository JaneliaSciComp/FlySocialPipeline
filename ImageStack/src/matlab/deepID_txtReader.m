function [bodyO,bratio,doppt,dwall,wingA,wingS]=...
    deepID_txtReader(text_file)
% Function (silly) to inport deepID configuration values
% from a .txt file so user might change them when needed 
% values should match thoughs used when making VGG model
%
% example .txt data (note [] in third column when needed):
%bodyO,-1.57,-0.01,body orientation (negative numbers default to all orientations)
%bratio,2.3,[],body length to width ratio
%doppt,3.2,[],distance between opponents
%dwall,7,[],distance from arena center
%wingA,1000,[],wing asymmetry
%wingS,0,50,wing spread
%
% JCSimon Oct 6 2020

%extract values from text file
opts=delimitedTextImportOptions('NumVariables',4);
T=readtable(text_file, opts);

%assign values to variables (lumberjack way!)
% body oriention
bodyO={str2double(T.Var2(1)) str2double(T.Var3(1))};

%Body length to width ratio
bratio=str2double(T.Var2(2));

% distance between opponents
doppt=str2double(T.Var2(3));

% distance from arnea center
dwall=str2double(T.Var2(4));

%wing asymmetry
wingA=str2double(T.Var2(5));

%wing spread
wingS=[str2double(T.Var2(6)) str2double(T.Var3(6))];
