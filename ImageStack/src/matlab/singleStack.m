function stack=singleStack(...
     x,y,BodyOrientFly,v,adjustmentDisplay)
% function to extract stack of images
% cropped to the x,y origin of a fly
% in:
% x, y of a focal fly
% BodyOrientFly, body orientations of fly
% v, v = VideoReader(movie); % extract frames from movie
% performed outside function
% fly, fly =1 or 2 
% adjustmentDisplay, print to screen progress with adjustments
% out: stack of images the same length
% as original movie
%
% JCSimon 7/8/2020

%prior
mask=18;
buffer=38;


% make buffer the dimensions of movie
stack=ones(buffer,buffer,size(x,2));

% make movie
for make=1:size(x,2)
    video = read(v,make); % read frames
    
    try
        %code to deal with round up/down past 1:144 the size of the total image
        x_min=floor(y(make))-mask;
        x_max=ceil(y(make))+mask;
        
        y_min=floor(x(make))-mask;
        y_max=ceil(x(make))+mask;
        
        % conditionals
        if x_min<1
            x_min=1;
            x_max=x_max+1;
        end
        
        if x_max>144
            x_max=144;
            x_min=x_min-1;
        end
        
        if y_min<1
            y_min=1;
            y_max=y_max+1;
        end
        
        if y_max>144
            y_max=144;
            y_min=y_min-1;
        end
        
        video_crop=video(x_min:x_max,y_min:y_max,1);
    catch
        disp('working on this')
    end
    try
        stack(:,:,make)=video_crop;
    catch % pad matrix with ones if needed to keep constant 38x38 size
        if size(video_crop,1)<38
            v_aid=uint8(ones(38-size(video_crop,1),size(video_crop,2))).*max(video_crop(:));
            % add to appropriate side
            % extract orientation from correct fly
%             if isequal(fly,1)
                side=BodyOrientFly(make);
%             else
%                 side=BodyOrientFly2(make);
%             end
            % use orientation to determine side to add buffer
            if side<0
                % top
                video_crop=[v_aid;video_crop];
            else
                % bottom
                video_crop=[video_crop;v_aid];
            end
        end
        
        if size(video_crop,2)<38
            %             h_aid=ones(38-size(video_crop,2),38);
            h_aid=uint8(ones(38, 38-size(video_crop,2))).*max(video_crop(:));
            % add to appropriate side
            % extract orientation from correct fly
%             if isequal(fly,1)
                side=BodyOrientFly(make);
%             else
%                 side=BodyOrientFly2(make);
%             end
            % use orientation to determine side to add buffer
            if abs(side)>pi/2 
                % left
                video_crop=[h_aid video_crop];
            else
                % right
                video_crop=[video_crop h_aid];
            end
        end
        stack(:,:,make)=video_crop;
        if isequal(adjustmentDisplay,1)
            whoops_val=sprintf('whoops, add to keep 38x38 (%d).',make);
            disp(whoops_val)
        end
    end
end

% convert video stack into uint8
stack=uint8(stack);