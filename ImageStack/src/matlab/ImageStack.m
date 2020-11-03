function deep=ImageStack(filePath,frames_out)
% Function to extract stack of images from movie for 
% error-correcting fly ID by deepID classifier (VGG, Sherry Ding)
%
% deep=ImageStack(filePath,frames_out);
%
% in:
% filePath, directory path to folder containing movie and trx files.
% frames_out, filtered frames used for deep output.
%
% out:
% deep, stacks of images for pair of lies and associated meta data.
% Note deepD{5} is euclidean distance between flies and might be
% useful as a filter for which frames might be used in deepID classifier.
%
% uses: 
% singleStack.m
% DistanceBtwFrames.m 
% DistanceBtwFlies.m
%
% saves:
% .../imageStackout.mat, containing deep
%
% JCSimon 10/10/2018 (modified from FrameCompile: 7/8/2020)

% get data from experimental folder
% movie file
movie=strcat(filePath,'/movie.avi'); % <-- file path to .avi

% x,y data
tracksFile=strcat(filePath,'/registered_trx.mat');
load(tracksFile)
data=trx; % trx file

% extract X,Y
fly1=1; fly2=2; % provide logical labels for each fly

% fly1
x1=data(fly1).x_mm;
y1=data(fly1).y_mm;

% fly2
x2=data(fly2).x_mm;
y2=data(fly2).y_mm;

% clean up
clear timestamps trx data tracksFile

% extract orientation
perframe_theta=strcat(filePath, '/perframe/theta.mat');
load(perframe_theta);

BodyOrientFly{1}=data{1}; BodyOrientFly{2}=data{2};

% clean up
clear data units

% Determine Euclidean distance 
% between frames
% fly1
Ed1=DistanceBtwFrames(x1,y1); Ed1=[Ed1(1) Ed1]; % replicate first frame
Ed{1}=Ed1;

%fly2
Ed2=DistanceBtwFrames(x2,y2); Ed2=[Ed2(1) Ed2]; % replicate first frame
Ed{2}=Ed2;

%between flies
Ed=DistanceBtwFlies(x1,y1,x2,y2);

% extract frames from movie
v = VideoReader(movie);

% fly 1
stack1=singleStack(...
    x1,y1,BodyOrientFly{fly1},v,0);

% fly 2
stack2=singleStack(...
    x2,y2,BodyOrientFly{fly2},v,0);

% slice through full stack with inputted filter
%image stacks
stack1=stack1(:,:,frames_out{fly1});
stack2=stack2(:,:,frames_out{fly2});
% frames
stack1n=frames_out{fly1};
stack2n=frames_out{fly2};
% distance between frames for each fly
Ed1=Ed1(frames_out{fly1});
Ed2=Ed2(frames_out{fly2});
% distance between flies across frames
Ed=Ed;

% bundle data fly 1
% forward
deepdata.video_cropSTACK=stack1;
frameNumber1=1:size(x1,2);
deepdata.frameNUM=frameNumber1(stack1n);
deepdata.clipID=nan; % changed
deepdata.EuclidDist=Ed1;
deepdata.filePATH=movie;
deepdata.filter_config=nan; % changed
deepdata.notes='fly 1 forward direction';

deep{1}=deepdata;

clear deepdata

% reverse
deepdata.video_cropSTACK=flip(stack1,3);
frameNumber1=1:size(x1,2);
deepdata.frameNUM=frameNumber1(stack1n); % these aren't real frames; deepID can't deal with decreasing frames; needs to be worked out in voteID step
deepdata.clipID=nan; % changed
deepdata.EuclidDist=flip(Ed1);
deepdata.filePATH=movie;
deepdata.filter_config=nan; % changed
deepdata.notes='fly 1 reverse direction';

deep{2}=deepdata;

clear deepdata

% fly 2
deepdata.video_cropSTACK=stack2;
frameNumber2=1:size(x2,2);
deepdata.frameNUM=frameNumber2(stack2n);
deepdata.clipID=nan; % changed
deepdata.EuclidDist=Ed2;
deepdata.filePATH=movie;
deepdata.filter_config=nan; % changed
deepdata.notes='fly 2 forward direction';

deep{3}=deepdata;

clear deepdata

% reverse
deepdata.video_cropSTACK=flip(stack2,3);
frameNumber2=1:size(x2,2);
deepdata.frameNUM=frameNumber2(stack2n); % these aren't real frames; deepID can't deal with decreasing frames; needs to be worked out in voteID step
deepdata.clipID=nan; % changed
deepdata.EuclidDist=flip(Ed2);
deepdata.filePATH=movie;
deepdata.filter_config=nan; % changed
deepdata.notes='fly 2 reverse direction';

deep{4}=deepdata;

clear deepdata

deep{5}=Ed;
deep{6}='cells: {1},{2},{3},{4} are stacks, frame-wise euclidean distance, and meta data for each fly ({2} & {4} are reversed stacks of {1} & {3}, repectively); {5} is euclidean distance btw flies for each frame. Use data from each fly as deepdata=deep{1} for deepID input.';
    
% save
save_val=strcat(filePath,'/imageStackout.mat'); 
save(save_val, 'deep');