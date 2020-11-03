function P=Dominance_PreFramePathFinder(GUI_val,path)
% Function to get experimental data either via a
% GUI prompt or using a path directory
%
% P=DominancePreFramePathFinder(GUI_val,path)
%
% input:
% vis GUI or folder directory path
%
% output: 
% P, is a strux variable packed with data from 
% various .mat files.
%
% JCSimon 8/16/2019

cur_dir=pwd;
if isequal(GUI_val,1)
    % extract data from arbitray experiment
    try
        cd('/Volumes/heberleinlab/Simon/Summer_2018/LearningSet'); % experimental files on dm11
    catch
        cd('/Users/simonj10/Desktop/LearningSet'); % <-- files on Mac
    end
    P.path=uigetdir; cd(P.path); % move into selected experimental folder
    P.movie_name=dir('*.avi'); movie_name=P.movie_name(1).name;% extract files with .avi extention 
else
    % GUI isn't used
    P.path=path; cd(P.path); % move into selected experimental folder 
    P.movie_name=dir('*.avi'); movie_name=P.movie_name(1).name;% extract files with .avi extention
end

cd(cur_dir); % move back to starting directory

P.movie=sprintf('%s/%s',P.path, movie_name);
P.data_path=sprintf('%s/%s',P.path,'registered_trx.mat');
P.perframe_n2tpath=sprintf('%s/%s',P.path,'perframe/dnose2tail.mat');
P.perframe_n2bpath=sprintf('%s/%s',P.path,'perframe/dnose2ell.mat');
% metric encoding position of the closest fly:
P.perframe_anglefrom1to2path=sprintf('%s/%s',P.path,'perframe/anglefrom1to2_nose2ell.mat');
% metric that encodes what the current fly is pointing at on the closest fly:
P.perframe_angleonclosestflypath=sprintf('%s/%s',P.path,'perframe/angleonclosestfly.mat');
% metric that encodes approach speed
P.perframe_approachspeed=sprintf('%s/%s',P.path,'perframe/veltoward_nose2ell.mat');
% metric that encodes left wing areas
P.perframe_wingareaL=sprintf('%s/%s',P.path,'perframe/wing_areal_mm.mat');
% metric that encodes left wing areas
P.perframe_wingareaR=sprintf('%s/%s',P.path,'perframe/wing_arear_mm.mat');
% metric that encodes angle imbalance between wings
P.perframe_wingImbal=sprintf('%s/%s',P.path,'perframe/wing_angle_imbalance.mat');
% metric stating number of wings (if any) detected in frame
P.perframe_numWings=sprintf('%s/%s',P.path,'perframe/nwingsdetected.mat');
% metric for body orientation detected in frame (JcSimon 10/5/2018)
P.perframe_theta=sprintf('%s/%s',P.path,'perframe/theta.mat');