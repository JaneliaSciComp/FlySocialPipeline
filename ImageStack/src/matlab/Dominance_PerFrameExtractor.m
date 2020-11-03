function M=Dominance_PerFrameExtractor(...
    movie,frames,...
    data_path,perframe_n2tpath,perframe_n2bpath,...
    perframe_anglefrom1to2path,perframe_angleonclosestflypath,...
    pixelmeasure,perframe_wingareaL,perframe_wingareaR,...
    perframe_wingImbal,perframe_numWings,perframe_theta)
% Function to extract, calculate, and package various per-frame metrics:
% M=DominancePerFrameExtractor(...
%     movie,frames,...
%     data_path,perframe_n2tpath,perframe_n2bpath,...
%     perframe_anglefrom1to2path,perframe_angleonclosestflypath,...
%     pixelmeasure,perframe_wingareaL,perframe_wingareaR,...
%     perframe_wingImbal,perframe_numWings)
%
% inputs:
% movie
% frames
% data_path
% ...and a bunch of perframe inputs
%
% output:
% M, strux variable containing various perframe metrics
%
% uses:
% Frames_Extract.m
% AggressionArena_VideoCalibrate.m
% Feature_Reader.m
% XY_Flies.m
% Distance_FromWall.m
% Distance_BtwFlies.m (this might be 2nd w/ name?)
% Body_Size.m
% Wing_Symmetry.m
%
% JCSimon 8/16/2019 (Modified 8/28/2018)

% extract video frames
M.videoFrames=Frames_Extract(movie, frames);

% measured pixel lengths:
% [162.69 162.69 164.05 161.25 161.94 163.34 161.32 163.34 161.94 163.47]
% pixelmeasure=0; if 0 used pre-measured length and skip GUI step
if isequal(pixelmeasure,1)
    [pixel_length, adjust]=AggressionArena_VideoCalibrate(M.videoFrames, 19.5,1,162.6); % 19.5 is length of X-to-X [mm]; 162.6 is length in pixels
else
    [pixel_length, adjust]=AggressionArena_VideoCalibrate(M.videoFrames, 19.5,0,162.6);
end

% extract trx
M.trx=Feature_Reader(data_path);

% extract nose to tail preframe
preFrameN2T=load(perframe_n2tpath); M.dn2tfly1=preFrameN2T.data{1}; M.dn2tfly2=preFrameN2T.data{2}; % distances between nose and tail

% extract nose to body preframe
preFrameN2B=load(perframe_n2bpath); M.dn2bfly1=preFrameN2B.data{1}; M.dn2bfly2=preFrameN2B.data{2}; % distances between nose and body (center of ellipse)

% extract angle from second fly preframe
preFrameAfrom=load(perframe_anglefrom1to2path); M.anglefromfly1=preFrameAfrom.data{1}*180/pi; M.anglefromfly2=preFrameAfrom.data{2}*180/pi;

% extract angle on second fly preframe
preFrameAon=load(perframe_angleonclosestflypath); M.angleONfly1=preFrameAon.data{1}*180/pi; M.angleONfly2=preFrameAon.data{2}*180/pi;

% extract area of left and right wings fly preframe
preFrameAreaL=load(perframe_wingareaL); M.WingAreaLfly1=preFrameAreaL.data{1}; M.WingAreaLfly2=preFrameAreaL.data{2};
preFrameAreaR=load(perframe_wingareaR); M.WingAreaRfly1=preFrameAreaR.data{1}; M.WingAreaRfly2=preFrameAreaR.data{2};

% extract wing imbalance preframe
perFrame_wingImbal=load(perframe_wingImbal); M.WingAngleIMbfly1=perFrame_wingImbal.data{1}; M.WingAngleIMbfly2=perFrame_wingImbal.data{2};

preFrame_numWings=load(perframe_numWings); M.NumWingsfly1=preFrame_numWings.data{1}; M.NumWingsfly2=preFrame_numWings.data{2};

% % extract approach spped preframe
% preFrameApSpeed=load(perframe_approachspeed); approachSPEED1=preFrameApSpeed.data{1}; approachSPEED2=preFrameApSpeed.data{2};

% x,y coordinates of flies' positions over time
[M.x1,M.y1,M.x2,M.y2,M.x1p,M.y1p,M.x2p,M.y2p]= XY_Flies(M.trx, adjust);

% distance from origin for flies over time
[M.distFromOrigin1,M.distFromOrigin2,M.x_origin,M.y_origin]=Distance_FromWall(M.x1,M.y1,M.x2,M.y2);

% distance between flies over time
M.DistBtw=DistanceBtwFlies(M.x1,M.y1,M.x2,M.y2);

% ratio of length / width of flies over time
[M.bodyRatio1,M.bodyRatio2,M.bodyLength1,M.bodyWidth1,M.bodyLength2,M.bodyWidth2]=Body_Size(M.trx, adjust);

% symmetry of wing spread for flies over time
[M.wingSymty1,M.wingSymty2,M.wingSprd1,M.wingSprd2]=Wing_Symmetry(M.trx);

% orientation
perframe_theta=load(perframe_theta); M.BodyOrientFly1=perframe_theta.data{1};M.BodyOrientFly2=perframe_theta.data{2};