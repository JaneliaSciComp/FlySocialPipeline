function stackimageViewer(s1,s2,f)
% function to visualize side-by-side
% the cropped, extracted per-frame 
% images for pairs of flies
%
% in: s1,s2 (each a 38,38, n stack of images)
% f, frame number
% JCSimon 7/9/2020

figure
subplot(1,2,1)
imshow(s1(:,:,f),'InitialMagnification',500)
subplot(1,2,2)
imshow(s2(:,:,f),'InitialMagnification',500)
