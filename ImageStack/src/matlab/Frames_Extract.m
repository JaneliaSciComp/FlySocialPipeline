function video=Frames_Extract(movie_path, frames)
% Function to load and extract frames from 
% .AVI or Mpg4(?) digital videos
%
% video=FramesExtract(movie_path, frames)
%
% Input: 
% file path to .AVI file
% frames
% Output: video, frames of video

% JCSimon 7/18/2018

v = VideoReader(movie_path); % determine properties of video
video = read(v,frames); % extract frame(s) from video