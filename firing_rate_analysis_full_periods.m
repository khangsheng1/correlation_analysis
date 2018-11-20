%% Correlation Analysis of Grip Force Spike Data
%  Brittany Moore - brittanymoore16@gmail.com
%       Originally for One Directional Center Out Reaching

%  Edited by Sheng Khang for GF task - khangsheng1@gmail.com
%  This is an edit of my original code. This will all be coded my own way,
%  instead of following the work of Brittany. After finding that Junmo's
%  codes didn't give the correct trial label I made my own extraction code.
%  This is code was created partly because of that, I don't trust other
%  people's codes.

%  11/3/2018

clear;close all;clc;

% Selects file names the session that is to be extracted. This
% also changes the current folder into the selected files pathname. For
% this code, the data from the NAS have to have been already extracted
% using my "extract_spike_from_mat_file.m" code then ran through
% "extract_spike.m" to get the DatDir saved file from the specific session.
% this is saved into pre and post cue/reward. Selecting either, but not
% both pre and post would make the code work.

[FileName, pathname] = uigetfile('*.mat', 'Select the MATLAB code file',...
    'MultiSelect', 'on');
trial_number = length(FileName);

cd ../..
cd (pathname)

%% Start at first selected trial

for fn = 1:trial_number
    %% Load Pre and Post data
    
    F = FileName(fn);
    filename = extractAfter(F, 'Extracted_');
    monkey_label = extractBefore(filename,'_');
    if str2num(cell2mat(monkey_label)) == 0059
        monkey_name = 'Soph';
    else
        monkey_name = 'PG';
    end
    
    namepre = ['DatDir_Pre_EXTRACTED_', cell2mat(filename),' '];
    namepost = ['DatDir_Post_EXTRACTED_', cell2mat(filename),''];
    
    Pre = [];
    Post = [];
    
    % Temporarily store PRE and POST
    DatDir = [];
    load (namepre);
    pre_Cue_R_Direct = DatDir.SpikeC_R;
    pre_Rew_R_Direct = DatDir.SpikeR_R;
    pre_Cue_NR_Direct = DatDir.SpikeC_NR;
    pre_Rew_NR_Direct = DatDir.SpikeR_NR;
    
    DatDir = [];
    load (namepost);
    post_Cue_R_Direct = DatDir.SpikeC_R;
    post_Rew_R_Direct = DatDir.SpikeR_R;
    post_Cue_NR_Direct = DatDir.SpikeC_NR;
    post_Rew_NR_Direct = DatDir.SpikeR_NR;
    
    [R_trials,~,~] = size(DatDir.SpikeC_R);
    [NR_trials,~,unit_number] = size(DatDir.SpikeC_NR);
    
    %% Put the pre and post cue/reward together (concatenate)
    cue_NR = [pre_Cue_NR_Direct post_Cue_NR_Direct];
    cue_R = [pre_Cue_R_Direct post_Cue_R_Direct];
    rew_NR = [pre_Rew_NR_Direct post_Rew_NR_Direct];
    rew_R = [pre_Rew_R_Direct post_Rew_R_Direct];
    
    %% Find average of population
    
    trial_length = 1000;
    for m = 1:unit_number
        for n = 1:trial_length
            average_for_unit_cue_NR(m,n) = mean(cue_NR(:,n,m));
            average_for_unit_rew_NR(m,n) = mean(rew_NR(:,n,m));
        end
    end
    
    for m = 1:unit_number
        for n = 1:trial_length
            average_for_unit_cue_R(m,n) = mean(cue_R(:,n,m));
            average_for_unit_rew_R(m,n) = mean(rew_R(:,n,m));
        end
    end
    
    %% Binned data of units (from averaged data)
    
    bin_size = 100;
    move_by = 5;
    
    for m = 1:unit_number
        n = 1;
        while n < (trial_length - bin_size + 2)
            binned_cue_NR(m,n) = sum(average_for_unit_cue_NR(m,n:n+bin_size-1));
            binned_rew_NR(m,n) = sum(average_for_unit_rew_NR(m,n:n+bin_size-1));
            binned_cue_R(m,n) = sum(average_for_unit_cue_R(m,n:n+bin_size-1));
            binned_rew_R(m,n) = sum(average_for_unit_rew_R(m,n:n+bin_size-1));
            n = n+5;
        end
    end
    
    % Takes all zero columns away. These zero columns are generated in the
    % previous loops when n jumps by 5 numbers
    
    binned_cue_NR = binned_cue_NR(:,any(binned_cue_NR,1));
    binned_rew_NR = binned_rew_NR(:,any(binned_rew_NR,1));
    binned_cue_R = binned_cue_R(:,any(binned_cue_R,1));
    binned_rew_R = binned_rew_R(:,any(binned_rew_R,1));
    
    %% Find Geometric mean of data
    %  geometric mean is used because it isn't as sensitive to outliers as
    %  arithmetic mean
    
    geomean_mmn_cue_NR = sum(binned_cue_NR).^(1/unit_number);
    geomean_mmn_rew_NR = sum(binned_rew_NR).^(1/unit_number);
    geomean_mmn_cue_R = sum(binned_cue_R).^(1/unit_number);
    geomean_mmn_rew_R = sum(binned_rew_R).^(1/unit_number);
    
    %% Min/Max Normalization
    
    everything_together = [geomean_mmn_cue_NR geomean_mmn_rew_NR geomean_mmn_cue_R ...
        geomean_mmn_rew_R];
    
    min_everything = min(min(everything_together));
    max_everything = max(max(everything_together));
    
    mmn_cue_NR(fn,:) = (geomean_mmn_cue_NR(:,:) - min_everything)/(max_everything - ...
        min_everything);
    mmn_rew_NR(fn,:) = (geomean_mmn_rew_NR(:,:) - min_everything)/(max_everything - ...
        min_everything);
    mmn_cue_R(fn,:) = (geomean_mmn_cue_R(:,:) - min_everything)/(max_everything - ...
        min_everything);
    mmn_rew_R(fn,:) = (geomean_mmn_rew_R(:,:) - min_everything)/(max_everything - ...
        min_everything);
    
    clearvars -except FileName pathname trial_number fn mmn_cue_NR mmn_rew_NR ...
        mmn_cue_R mmn_rew_R monkey_name
    
end
disp('Starting the averaging part')
%% Find average FR across trial types

size_mmn = size(mmn_cue_NR);

average_cue_NR = [];average_cue_R = [];average_rew_NR = [];average_rew_R = [];

for m = 1:size_mmn(2)
    average_cue_NR(:,m) = mean(mmn_cue_NR(:,m));
    average_cue_R(:,m) = mean(mmn_cue_R(:,m));
    average_rew_NR(:,m) = mean(mmn_rew_NR(:,m));
    average_rew_R(:,m) = mean(mmn_rew_R(:,m));
end

%% Plotting firing rate
begin_location = 81;
end_location = 101;
numBINS = length(average_cue_NR);

figure
x1 = 1:numBINS;
p = plot(x1,average_cue_NR,'b',x1,average_cue_R,'r','Linewidth',1);
hold on
y1 = ylim;
Ptch = patch([begin_location end_location end_location begin_location], ...
    [ 0 0 y1(2) y1(2)],[0.9 0.9 0.9],'LineStyle','--');
hold on
plot(x1,average_cue_NR,'b',x1,average_cue_R,'r','Linewidth',1)
hold off
title(['Normalized Pre and Post Cue firing rate of ' monkey_name])
xlabel('Time Bin #')
legend([p(1) p(2) Ptch],'Nonrewarding','Rewarding','Cue bin overlap','Location','best')

figure
x1 = 1:numBINS;
p = plot(x1,average_rew_NR,'b',x1,average_rew_R,'r','Linewidth',1);
hold on
y1 = ylim;
Ptch = patch([begin_location end_location end_location begin_location], ...
    [ 0 0 y1(2) y1(2)],[0.9 0.9 0.9],'LineStyle','--');
hold on
plot(x1,average_rew_NR,'b',x1,average_rew_R,'r','Linewidth',1)
hold off
title(['Normalized Pre and Post Reward firing rate of ' monkey_name])
xlabel('Time Bin #')
legend([p(1) p(2) Ptch],'Nonrewarding','Rewarding','Reward bin overlap','Location','best')
