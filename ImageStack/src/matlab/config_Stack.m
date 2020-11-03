function frames_out=config_Stack(filePath,config_file,frames)
% Function to generate filter for frames withing a movie containing 
% pairs of flies to use for fly IDing based on the flies' 
% wing clipping status (using VGG model).
%
% frames_out=config_Stack(filePath,config_val,frames)
%
% input:
% filePath, directory path to experimental folder.
% config_val, =1 to load configuration file or =0 to use default values.
% config_file, directory path to config files.
% frames, total number of frames in movie (20 minutes= 36000 @ 30fps).
%
% output:
% frames_out, a cell array with frames_out for fly '1' {1} and fly '2' {2}
%
% uses:
% Dominance_PreFramePathFinder.m
% Dominance_PerFrameExtractor.m
% VaildFrames_Identifier.m
%
% JCSimon 8/6/2020
% (Modified from scriptWhichFrames4IDtrx_viaFxn.m 7/18/2018)

% read config data from text file
[bodyO,bratio,doppt,dwall,wingA,wingS]=deepID_txtReader(config_file);

% This file contains the following default values:
%     % use default values configured for "Deep Learning" data set
%     dwall=7; % distance from arena center
%     doppt=3.2; % distance between males
%     bratio=2.3; % body length to width ratio
%     wingA=1000; % wing asymetry
%     wingS=[0 50]; % wing spread
%     bodyO={[-1.57], -.01}; % facing north (currently over-ridden by "-", and thus uses all coordinate directions)

% used for prototyping/testing.
GUI_val=0; % =1 uses GUI to file files.
pixelmeasure=0; % =1 whether or =0 not to calibrate distance for each movie
thresh_fig=0; % =1 plots figures showing filtering based on configured values

% configs
frames=1:frames; % this should be 1:total length of movie

% extracting required variables from code originally built for other tasks
%P
P=Dominance_PreFramePathFinder(GUI_val,filePath);

%M
M=Dominance_PerFrameExtractor(...
    P.movie,frames(end),...
    P.data_path,P.perframe_n2tpath,P.perframe_n2bpath,...
    P.perframe_anglefrom1to2path,P.perframe_angleonclosestflypath,...
    pixelmeasure,P.perframe_wingareaL,...
    P.perframe_wingareaR,P.perframe_wingImbal,...
    P.perframe_numWings,P.perframe_theta);

% identifies valid frames for filter for fly 1, 2
for fly=1:2
framesOUT=VaildFrames_Identifer(...
    M,frames,dwall,doppt,bratio,wingS,wingA,bodyO,thresh_fig,fly);
frames_out{fly}=framesOUT;
end