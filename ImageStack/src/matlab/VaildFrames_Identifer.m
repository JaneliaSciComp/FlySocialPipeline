function frames_out=VaildFrames_Identifer(...
    M,frames_in,dwall,doppt,bratio,wingS,wingA,bodyO,thresh_fig,fly)
% Function uses various inputed threshold values for various
% perframe states and finds "joint" data passing through, over, and
% under thresholds.
%
% frames_out=VaildFrames_Identifer(...
%    M,D,frames_in,dwall,doppt,bratio,wingS,wingA,bodyO,thresh_fig,fly)
%
% Inputs:
% M, various per-frame metrics and various thresholds
% make call for social status.
% frames_in, total frames in movie
%
% various filters
% (1) greater than some distance from wall (dwall)
% (2) greater than some distance from opponent (doppt)
% (3) greater than some ratio of body length to width (bratio)
% (4) between narrow, wide wing spread wingS: wingS(1) = narrrow wingS(2) =wide
% (5) measure of wing asymetry (wingA)
% 
% thresh_fly, plot =1 or not
% fly, which fly -- fly '1' or '2'
%
% Output: frames_out to be used for wing clipping ID
%
% JCSimon 8/6/2020 (modified from ValidFramesFinder 8/31/2018)

% select data for fly1 vs fly2
if isequal(fly,1)
    % fly '1'
    flydwall=M.distFromOrigin1(frames_in);
    flydoppt=M.DistBtw(frames_in);
    flybratio=M.bodyRatio1(frames_in);
    flywingspread=M.wingSprd1(frames_in);
    flywingasym=M.wingSymty1(frames_in);
    flyBodyOrient=M.BodyOrientFly1(frames_in);
    % fly '2'
else
    flydwall=M.distFromOrigin2(frames_in);
    flydoppt=M.DistBtw(frames_in);
    flybratio=M.bodyRatio2(frames_in);
    flywingspread=M.wingSprd2(frames_in);
    flywingasym=M.wingSymty2(frames_in);
    flyBodyOrient=M.BodyOrientFly2(frames_in);
end

% apply filters to perframe data
flydwall_filt=flydwall<dwall;
flydoppt_filt=flydoppt>doppt;
flybratio_filt=flybratio>bratio;
flywingspread_filt=flywingspread>=wingS(1)&flywingspread<wingS(2); % JCSimon changed > to >= (8/6/2020)
flywingasym_filt=abs(flywingasym)<wingA;

% orientation
if bodyO{2}<0
    flyBodyOrient_filt=logical(ones(size(flyBodyOrient)));
else
    
    Omin=bodyO{1}-bodyO{2};
    Omax=bodyO{1}+bodyO{2};
    
    for o_val=1:size(Omin,2)
        flyBodyOrient_f{o_val}=flyBodyOrient>Omin(o_val) & flyBodyOrient<Omax(o_val);
    end
    
    % determine unique frames
    flyBodyOrient_filt=sum(reshape([flyBodyOrient_f{:}],size(flyBodyOrient,2),size(Omin,2)),2)'; % nxm matters!
    flyBodyOrient_filt(flyBodyOrient_filt>1)=1;
    flyBodyOrient_filt=logical(flyBodyOrient_filt);
end

fly_filt=flydwall_filt+flydoppt_filt+flybratio_filt+flywingspread_filt+flywingasym_filt+flyBodyOrient_filt; % add up filters
fly_filt=fly_filt==6; % logical array for when all three are true

% output frames to use
frames_out=frames_in(fly_filt);

% text output
numberOFframes=sum(fly_filt); % outputs number of vaild frames
windowOFframes=size(fly_filt,2); % outputs total number of frames

if isequal(fly,1)
    text_val='Fly1';
    plot_dom_val=1;
else
    text_val='Fly2';
    plot_dom_val=510;
end

disp_val=sprintf('Frames used / out of total valid (%s): %d/%d',text_val,numberOFframes,windowOFframes);
disp(disp_val)

% plots (thresh figures for visual checking)
if isequal(thresh_fig,1)
    % temp to make sure I am working with the correct data
    figure('Position',[plot_dom_val,1300,500,180]);
    if isequal(fly,1)
        plot(1:size(frames_in,2), M.distFromOrigin1, 'ko')
    else
        plot(1:size(frames_in,2), M.distFromOrigin2, 'ko')
    end
    hold on
    plot(frames_in, flydwall, 'rx')
    plot(frames_in(flydwall_filt), flydwall(flydwall_filt), 'cs')
    title(text_val)
    box off
    ylabel('Distance from arena center[mm]', 'fontsize', 18);
    axis([-.1*size(frames_in,2) 1.1*(size(frames_in,2)) -1 8])
    
    figure('Position',[plot_dom_val,1040,500,180]);
    if isequal(fly,1)
        plot(1:size(frames_in,2), M.DistBtw, 'ko')
    else
        plot(1:size(frames_in,2), M.DistBtw, 'ko')
    end
    hold on
    plot(frames_in, flydoppt, 'rx')
    plot(frames_in(flydoppt_filt), flydoppt(flydoppt_filt), 'cs')
    title('Near Opponent')
    ylabel('Distance between flies[mm]', 'fontsize', 18);
    axis([-.1*size(frames_in,2) 1.1*(size(frames_in,2)) -1 12])
    box off
    
    figure('Position',[plot_dom_val,780,500,180]);
    if isequal(fly,1)
        plot(1:size(frames_in,2), M.bodyRatio1, 'ko')
    else
        plot(1:size(frames_in,2), M.bodyRatio2, 'ko')
    end
    hold on
    plot(frames_in, flybratio, 'rx')
    plot(frames_in(flybratio_filt), flybratio(flybratio_filt), 'cs')
    title('L/W Ratio')
    ylabel('Body length/width ratio', 'fontsize', 18);
    box off
    axis([-.1*size(frames_in,2) 1.1*(size(frames_in,2)) .5 5])
    
    figure('Position',[plot_dom_val,520,500,180]);
    if isequal(fly,1)
        plot(1:size(frames_in,2), M.wingSprd1, 'ko')
    else
        plot(1:size(frames_in,2), M.wingSprd2, 'ko')
    end
    hold on
    plot(frames_in, flywingspread, 'rx')
    plot(frames_in(flywingspread_filt), flywingspread(flywingspread_filt), 'cs')
    title('Wing spread')
    ylabel('Degree of wing spread', 'fontsize', 18);
    box off
    axis([-.1*size(frames_in,2) 1.1*(size(frames_in,2)) -15 175])
    
    figure('Position',[plot_dom_val,260,500,180]);
    if isequal(fly,1)
        plot(1:size(frames_in,2), M.wingSymty1, 'ko')
    else
        plot(1:size(frames_in,2), M.wingSymty2, 'ko')
    end
    hold on
    plot(frames_in, flywingasym, 'rx')
    plot(frames_in(flywingasym_filt), flywingasym(flywingasym_filt), 'cs')
    title('Wing asymmetry')
    ylabel('Degree of wing asymmetry', 'fontsize', 18);
    box off
    axis([-.1*size(frames_in,2) 1.1*(size(frames_in,2)) -150 150])
    
    % body orientation
    figure('Position',[plot_dom_val,1,500,180]);
    if isequal(fly,1)
        plot(1:size(frames_in,2), M.BodyOrientFly1, 'ko')
    else
        plot(1:size(frames_in,2), M.BodyOrientFly2, 'ko')
    end
    hold on
    plot(frames_in, flyBodyOrient, 'rx')
    plot(frames_in(flyBodyOrient_filt), flyBodyOrient(flyBodyOrient_filt), 'cs')
    title('Body Orientation')
    ylabel('Orientation (radians)', 'fontsize', 18);
    box off
    axis([-.1*size(frames_in,2) 1.1*(size(frames_in,2)) -4 4])
end