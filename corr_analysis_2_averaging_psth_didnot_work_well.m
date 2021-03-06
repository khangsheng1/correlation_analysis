%% Correlation Analysis of Grip Force Spike Data
%  Brittany Moore - brittanymoore16@gmail.com
%       Originally for One Directional Center Out Reaching

%  Edited by Sheng Khang for GF - khangsheng1@gmail.com
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

b = size(FileName);
session_number = length(FileName);

cd ../..
cd (pathname)

%% Start at first selected trial

for fn = 1:b(2)
    %% Load Pre and Post data
    
    clearvars -except FileName pathname trial_number fn Corr_INDEX b session_number
    
    F = FileName(fn);
    filename = extractAfter(F, 'Extracted_');
    monkey_label = extractBefore(filename{1,1},'_');
    if str2num(monkey_label) == 0059
        monkey_name = 'Soph';
    elseif str2num(monkey_label) == 504
        monkey_name = 'PG';
    else
        disp('Select correct DatDir files')
    end
    
    namepre = ['DatDir_Pre_EXTRACTED_', filename{1,1},' '];
    namepost = ['DatDir_Post_EXTRACTED_', filename{1,1},''];
    
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
            ind_binned_cue_NR(m,n) = sum(average_for_unit_cue_NR(m,n:n+bin_size-1));
            ind_binned_rew_NR(m,n) = sum(average_for_unit_rew_NR(m,n:n+bin_size-1));
            ind_binned_cue_R(m,n) = sum(average_for_unit_cue_R(m,n:n+bin_size-1));
            ind_binned_rew_R(m,n) = sum(average_for_unit_rew_R(m,n:n+bin_size-1));
            n = n+5;
        end
    end
    
    % Takes all zero columns away. These zero columns are generated in the
    % previous loops when n jumps by 5 numbers
    
    bin_start = 1:5:length(ind_binned_cue_NR);
    binned_cue_NR = ind_binned_cue_NR(:,bin_start,:);
    binned_rew_NR = ind_binned_rew_NR(:,bin_start,:);
    binned_cue_R = ind_binned_cue_R(:,bin_start,:);
    binned_rew_R = ind_binned_rew_R(:,bin_start,:);
    
    %% Min/Max Normalization
    
    everything_together = [binned_cue_NR binned_rew_NR binned_cue_R ...
        binned_rew_R];
    
    min_everything = min(min(everything_together));
    max_everything = max(max(everything_together));
    
    mmn_cue_NR_whole = (binned_cue_NR(:,:) - min_everything)/(max_everything - ...
        min_everything);
    mmn_rew_NR_whole = (binned_rew_NR(:,:) - min_everything)/(max_everything - ...
        min_everything);
    mmn_cue_R_whole = (binned_cue_R(:,:) - min_everything)/(max_everything - ...
        min_everything);
    mmn_rew_R_whole = (binned_rew_R(:,:) - min_everything)/(max_everything - ...
        min_everything);
    
    %% Seperate into pre and post of cue/rew
    
    cue_time_bin_start = 81;
    cue_time_bin_end = 101;
    matrixSize = size(mmn_cue_NR_whole);
    
    mmn_cue_NR_precue = mmn_cue_NR_whole(:,1:cue_time_bin_start);
    mmn_cue_NR_postcue = mmn_cue_NR_whole(:, ...
        cue_time_bin_end:matrixSize(2));
    
    mmn_cue_R_precue = mmn_cue_R_whole(:,1:cue_time_bin_start);
    mmn_cue_R_postcue = mmn_cue_R_whole(:, ...
        cue_time_bin_end:matrixSize(2));
    
    mmn_rew_NR_prerew = mmn_rew_NR_whole(:,1:cue_time_bin_start);
    mmn_rew_NR_postrew = mmn_rew_NR_whole(:, ...
        cue_time_bin_end:matrixSize(2));
    
    mmn_rew_R_prerew = mmn_rew_R_whole(:,1:cue_time_bin_start);
    mmn_rew_R_postrew = mmn_rew_R_whole(:, ...
        cue_time_bin_end:matrixSize(2));
    
    %% Demean (finding the noise)
    %  This is done because we want to see the corerlation of the variations
    %  (the noise) in the trial
    
    b = size(mmn_cue_NR_precue);
    
    for m = 1:b(2)
        mean_ind = mean(mmn_cue_NR_precue(:,m));
        noise_cue_NR_precue(:,m) = mmn_cue_NR_precue(:,m) - mean_ind;
        mean_ind = mean(mmn_cue_R_precue(:,m));
        noise_cue_R_precue(:,m) = mmn_cue_R_precue(:,m) - mean_ind;
        mean_ind = mean(mmn_rew_NR_prerew(:,m));
        noise_rew_NR_prerew(:,m) = mmn_rew_NR_prerew(:,m) - mean_ind;
        mean_ind = mean(mmn_rew_R_prerew(:,m));
        noise_rew_R_prerew(:,m) = mmn_rew_R_prerew(:,m) - mean_ind;
    end
    
    b = size(mmn_cue_R_postcue);
    
    for m = 1:b(2)
        mean_ind = mean(mmn_cue_NR_postcue(:,m));
        noise_cue_NR_postcue(:,m) = mmn_cue_NR_postcue(:,m) - mean_ind;
        mean_ind = mean(mmn_cue_R_postcue(:,m));
        noise_cue_R_postcue(:,m) = mmn_cue_R_postcue(:,m) - mean_ind;
        mean_ind = mean(mmn_rew_NR_postrew(:,m));
        noise_rew_NR_postrew(:,m) = mmn_rew_NR_postrew(:,m) - mean_ind;
        mean_ind = mean(mmn_rew_R_postrew(:,m));
        noise_rew_R_postrew(:,m) = mmn_rew_R_postrew(:,m) - mean_ind;
    end
    
    noise_cue_NR_precue = noise_cue_NR_precue';
    noise_cue_R_precue = noise_cue_R_precue';
    noise_rew_NR_prerew = noise_rew_NR_prerew';
    noise_rew_R_prerew = noise_rew_R_prerew';
    
    noise_cue_NR_postcue = noise_cue_NR_postcue';
    noise_cue_R_postcue = noise_cue_R_postcue';
    noise_rew_NR_postrew = noise_rew_NR_postrew';
    noise_rew_R_postrew = noise_rew_R_postrew';
    
    %% Correlation coefficients
    
    [Corr.Cue_Pre_R,Pval.Cue_Pre_R] = corr(noise_cue_R_precue,noise_cue_R_precue);
    [Corr.Cue_Pre_NR,Pval.Cue_Pre_NR] = corr(noise_cue_NR_precue,noise_cue_NR_precue);
    
    [Corr.Cue_Post_R,Pval.Cue_Post_R] = corr(noise_cue_R_postcue,noise_cue_R_postcue);
    [Corr.Cue_Post_NR,Pval.Cue_Post_NR] = corr(noise_cue_NR_postcue,noise_cue_NR_postcue);
    
    [Corr.Rew_Pre_R,Pval.Rew_Pre_R] = corr(noise_rew_R_prerew,noise_rew_R_prerew);
    [Corr.Rew_Pre_NR,Pval.Rew_Pre_NR] = corr(noise_rew_NR_prerew,noise_rew_NR_prerew);
    
    [Corr.Rew_Post_R,Pval.Rew_Post_R] = corr(noise_rew_R_postrew,noise_rew_R_postrew);
    [Corr.Rew_Post_NR,Pval.Rew_Post_NR] = corr(noise_rew_NR_postrew,noise_rew_NR_postrew);
    
    %% Finding P-value < 0.05
    
    % Pre cue NR
    IND = []; x = []; y = [];
    IND = find(Pval.Cue_Pre_NR(:,:) < 0.05 & Pval.Cue_Pre_NR(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Cue_Pre_NR),IND);
    corr_ind_Cue_Pre_NR = cat(2,x,y);
    
    % Pre cue R
    IND = []; x = []; y = [];
    IND = find(Pval.Cue_Pre_R(:,:) < 0.05 & Pval.Cue_Pre_R(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Cue_Pre_R),IND);
    corr_ind_Cue_Pre_R = cat(2,x,y);
    
    % Find the unit pairs that are significant in both R and NR trials
    similar_unit_pairs = [];
    similar_unit_pairs = intersect(corr_ind_Cue_Pre_NR,corr_ind_Cue_Pre_R,'rows');
    
    % Get rid of repeated unit pairs
    unique_unit_pairs = [];
    unique_unit_pairs = unique(sort(similar_unit_pairs,2),'rows');
    
    INDEX.cue_pre = unique_unit_pairs;
    
    % Post cue NR
    IND = []; x = []; y = [];
    IND = find(Pval.Cue_Post_NR(:,:) < 0.05 & Pval.Cue_Post_NR(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Cue_Post_NR),IND);
    corr_ind_Cue_Post_NR = cat(2,x,y);
    
    % Post cue R
    IND = []; x = []; y = [];
    IND = find(Pval.Cue_Post_R(:,:) < 0.05 & Pval.Cue_Post_R(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Cue_Post_R),IND);
    corr_ind_Cue_Post_R = cat(2,x,y);
    
    % Find the unit pairs that are significant in both R and NR trials
    similar_unit_pairs = [];
    similar_unit_pairs = intersect(corr_ind_Cue_Post_NR,corr_ind_Cue_Post_R,'rows');
    
    % Get rid of repeated unit pairs
    unique_unit_pairs = [];
    unique_unit_pairs = unique(sort(similar_unit_pairs,2),'rows');
    
    INDEX.cue_post = unique_unit_pairs;
    
    % Pre rew NR
    IND = []; x = []; y = [];
    IND = find(Pval.Rew_Pre_NR(:,:) < 0.05 & Pval.Rew_Pre_NR(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Rew_Pre_NR),IND);
    corr_ind_Rew_Pre_NR = cat(2,x,y);
    
    % Pre rew R
    IND = []; x = []; y = [];
    IND = find(Pval.Rew_Pre_R(:,:) < 0.05 & Pval.Rew_Pre_R(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Rew_Pre_R),IND);
    corr_ind_Rew_Pre_R = cat(2,x,y);
    
    % Find the unit pairs that are significant in both R and NR trials
    similar_unit_pairs = [];
    similar_unit_pairs = intersect(corr_ind_Rew_Pre_NR,corr_ind_Rew_Pre_R,'rows');
    
    % Get rid of repeated unit pairs
    unique_unit_pairs = [];
    unique_unit_pairs = unique(sort(similar_unit_pairs,2),'rows');
    
    INDEX.rew_pre = unique_unit_pairs;
    
    % Post rew NR
    IND = []; x = []; y = [];
    IND = find(Pval.Rew_Post_NR(:,:) < 0.05 & Pval.Rew_Post_NR(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Rew_Post_NR),IND);
    corr_ind_Rew_Post_NR = cat(2,x,y);
    
    % Post rew R
    IND = []; x = []; y = [];
    IND = find(Pval.Rew_Post_R(:,:) < 0.05 & Pval.Rew_Post_R(:,:) > 0);
    
    % Find the corrdinates for where the pvalue is less than 0.05 but larger
    % than 0 and save the to a temporary array
    [x,y] = ind2sub(size(Pval.Rew_Post_R),IND);
    corr_ind_Rew_Post_R = cat(2,x,y);
    
    % Find the unit pairs that are significant in both R and NR trials
    similar_unit_pairs = [];
    similar_unit_pairs = intersect(corr_ind_Rew_Post_NR,corr_ind_Rew_Post_R,'rows');
    
    % Get rid of repeated unit pairs
    unique_unit_pairs = [];
    unique_unit_pairs = unique(sort(similar_unit_pairs,2),'rows');
    
    INDEX.rew_post = unique_unit_pairs;
    
    %% Plotting correlation coefficients
    
    ii = [];
    for ii = 1:length(INDEX.cue_pre)
        Corr_index.precue_NR_list(ii,:) = Corr.Cue_Pre_NR(INDEX.cue_pre(ii,1), ...
            INDEX.cue_pre(ii,2));
        Corr_index.precue_R_list(ii,:) = Corr.Cue_Pre_R(INDEX.cue_pre(ii,1), ...
            INDEX.cue_pre(ii,2));
    end
    
    ii = [];
    for ii = 1:length(INDEX.cue_post)
        Corr_index.postcue_NR_list(ii,:) = Corr.Cue_Post_NR(INDEX.cue_post(ii,1), ...
            INDEX.cue_post(ii,2));
        Corr_index.postcue_R_list(ii,:) = Corr.Cue_Post_R(INDEX.cue_post(ii,1), ...
            INDEX.cue_post(ii,2));
    end
    
    ii = [];
    for ii = 1:length(INDEX.rew_pre)
        Corr_index.prerew_NR_list(ii,:) = Corr.Rew_Pre_NR(INDEX.rew_pre(ii,1), ...
            INDEX.rew_pre(ii,2));
        Corr_index.prerew_R_list(ii,:) = Corr.Rew_Pre_R(INDEX.rew_pre(ii,1), ...
            INDEX.rew_pre(ii,2));
    end
    
    ii = [];
    for ii = 1:length(INDEX.rew_post)
        Corr_index.postrew_NR_list(ii,:) = Corr.Rew_Post_NR(INDEX.rew_post(ii,1), ...
            INDEX.rew_post(ii,2));
        Corr_index.postrew_R_list(ii,:) = Corr.Rew_Post_R(INDEX.rew_post(ii,1), ...
            INDEX.rew_post(ii,2));
    end
    
    Corr_INDEX(fn,1) = Corr_index;
    disp(['Finished session number ' num2str(fn)])
end

F = FileName{1,fn};
filename = extractAfter(F, 'Extracted_');
save([monkey_label '_Corr_index_2'], 'Corr_INDEX')

clearvars -except FileName pathname trial_number fn Corr_INDEX b session_number