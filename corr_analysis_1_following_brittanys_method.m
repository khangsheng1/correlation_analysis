%% Correlation Analysis of Grip Force Spike Data
%  Brittany Moore - brittanymoore16@gmail.com
%       Originally for One Directional Center Out Reaching
%  Edited by Sheng Khang for GF - khangsheng1@gmail.com
%  10/2/2018

clear;close all;clc;

% Selects file names the session that is to be extracted. This
% also changes the current folder into the selected files pathname

[FileName, pathname] = uigetfile('*.mat', 'Select the MATLAB code file',...
    'MultiSelect', 'on');
trial_number = length(FileName);

cd ../..
cd (pathname)

%% Start at first selected trial

for fn = 1:trial_number
    %% Load Pre and Post data
    
    clearvars -except FileName pathname trial_number fn Corr_INDEX
    
    F = FileName{1,fn};
    filename = extractAfter(F, 'Extracted_');
    
    namepre = ['DatDir_Pre_EXTRACTED_', filename,' '];
    namepost = ['DatDir_Post_EXTRACTED_', filename,''];
    
    % Temporarily store PRE and POST
    load (namepre);
    Pre.Cue_R_Direct = DatDir.SpikeC_R;
    Pre.Rew_R_Direct = DatDir.SpikeR_R;
    Pre.Cue_NR_Direct = DatDir.SpikeC_NR;
    Pre.Rew_NR_Direct = DatDir.SpikeR_NR;
    
    load (namepost);
    Post.Cue_R_Direct = DatDir.SpikeC_R;
    Post.Rew_R_Direct = DatDir.SpikeR_R;
    Post.Cue_NR_Direct = DatDir.SpikeC_NR;
    Post.Rew_NR_Direct = DatDir.SpikeR_NR;
    
    [R_trials,~,~] = size(DatDir.SpikeC_R);
    [NR_trials,~,unit_number] = size(DatDir.SpikeC_NR);
    
    
    %% Concatenate and minmax normalize
    
    for unit = 1:unit_number
        for trial = 1:R_trials
            CUE_WHOLE_R(trial,:,unit) = cat(2,Pre.Cue_R_Direct(trial,:,unit), ...
                Post.Cue_R_Direct(trial,:,unit));
            REW_WHOLE_R(trial,:,unit) = cat(2,Pre.Rew_R_Direct(trial,:,unit), ...
                Post.Rew_R_Direct(trial,:,unit));
        end
        for trial = 1:NR_trials
            CUE_WHOLE_NR(trial,:,unit) = cat(2,Pre.Cue_NR_Direct(trial,:,unit), ...
                Post.Cue_NR_Direct(trial,:,unit));
            REW_WHOLE_NR(trial,:,unit) = cat(2,Pre.Rew_NR_Direct(trial,:,unit), ...
                Post.Rew_NR_Direct(trial,:,unit));
        end
    end
    
    bin_size=100;
    move_by = 5;
    
    cue_length = length(CUE_WHOLE_R);
    rew_length = length(REW_WHOLE_R);
    
    % Concatenate Rewarding trials
    
    trial_length = cue_length;
    BIN_start = 1:move_by:trial_length-(bin_size-1);
    BIN_end = BIN_start + bin_size -1;
    
    for unit = 1:unit_number
        for trial = 1:R_trials
            for bin_num=1:length(BIN_end)
                R_CUE_binned_by_trial{unit}(bin_num,trial) = ...
                    sum(CUE_WHOLE_R(trial,BIN_start(bin_num):BIN_end(bin_num),unit));
            end
        end
    end
    trial_length = rew_length;
    BIN_start = 1:move_by:trial_length-(bin_size-1);
    BIN_end = BIN_start + bin_size -1;
    for unit = 1:unit_number
        for trial = 1:R_trials
            for bin_num=1:length(BIN_end)
                R_REW_binned_by_trial{unit}(bin_num,trial) = ...
                    sum(REW_WHOLE_R(trial,BIN_start(bin_num):BIN_end(bin_num),unit));
            end
        end
    end
    
    % Concatenate Non-Rewarding trials
    trial_length = cue_length;
    BIN_start = 1:move_by:trial_length-(bin_size-1);
    BIN_end = BIN_start + bin_size -1;
    
    for unit = 1:unit_number
        for trial = 1:NR_trials
            for bin_num=1:length(BIN_end)
                NR_CUE_binned_by_trial{unit}(bin_num,trial) = ...
                    sum(CUE_WHOLE_NR(trial,BIN_start(bin_num):BIN_end(bin_num),unit));
            end
        end
    end
    trial_length = rew_length;
    BIN_start = 1:move_by:trial_length-(bin_size-1);
    BIN_end = BIN_start + bin_size -1;
    for unit = 1:unit_number
        for trial = 1:NR_trials
            for bin_num=1:length(BIN_end)
                NR_REW_binned_by_trial{unit}(bin_num,trial) = ...
                    sum(REW_WHOLE_NR(trial,BIN_start(bin_num):BIN_end(bin_num),unit));
            end
        end
    end
    
    for unit=1:unit_number
        R_concat_cue(unit,:) = reshape(R_CUE_binned_by_trial{unit},1, ...
            size(R_CUE_binned_by_trial{unit},1)*size(R_CUE_binned_by_trial{unit},2));
        NR_concat_cue(unit,:) = reshape(NR_CUE_binned_by_trial{unit},1, ...
            size(NR_CUE_binned_by_trial{unit},1)*size(NR_CUE_binned_by_trial{unit},2));
        R_concat_rew(unit,:) = reshape(R_REW_binned_by_trial{unit},1, ...
            size(R_REW_binned_by_trial{unit},1)*size(R_REW_binned_by_trial{unit},2));
        NR_concat_rew(unit,:) = reshape(NR_REW_binned_by_trial{unit},1, ...
            size(NR_REW_binned_by_trial{unit},1)*size(NR_REW_binned_by_trial{unit},2));
    end
    
    for unit =1:unit_number
        WHOLE_ALL_unit_binned(unit,:) = [R_concat_cue(unit,:), ...
            NR_concat_cue(unit,:), R_concat_rew(unit,:), NR_concat_rew(unit,:)];
        minVal = min(WHOLE_ALL_unit_binned(unit,:));
        maxVal = max(WHOLE_ALL_unit_binned(unit,:));
        WHOLE_ALL_unit_min_max_norm(unit,:) = (WHOLE_ALL_unit_binned(unit,:) ...
            - minVal)/(maxVal-minVal);
    end
    
    
    %% separate after min/max normalization
    % mmn = min/max normalization
    for unit=1:unit_number
        R_concat_cue_mmn(unit,:) = WHOLE_ALL_unit_min_max_norm(unit,1: ...
            length(R_concat_cue));
        total = length(R_concat_cue);
        NR_concat_cue_mmn(unit,:) = WHOLE_ALL_unit_min_max_norm(unit,total+1: ...
            total+length(NR_concat_cue));
        total = total+length(NR_concat_cue);
        R_concat_rew_mmn(unit,:) = WHOLE_ALL_unit_min_max_norm(unit,total+1: ...
            total+length(R_concat_rew));
        total = total+length(R_concat_rew);
        NR_concat_rew_mmn(unit,:) = WHOLE_ALL_unit_min_max_norm(unit,total+1: ...
            total+length(NR_concat_rew));
    end
    
    c_len = ((cue_length-bin_size)/move_by)+1;
    r_len = ((rew_length-bin_size)/move_by)+1;
    
    for unit = 1:unit_number
        total_c = 0; total_r = 0;
        for trial = 1:R_trials
            R_CUE_mmn(trial,:,unit) = R_concat_cue_mmn(unit,total_c+1:total_c+c_len);
            total_c = total_c+c_len;
            R_REW_mmn(trial,:,unit) = R_concat_rew_mmn(unit,total_r+1:total_r+r_len);
            total_r = total_r+r_len;
        end
        total_c = 0; total_r = 0;
        for trial = 1:NR_trials
            NR_CUE_mmn(trial,:,unit) = NR_concat_cue_mmn(unit,total_c+1:total_c+c_len);
            total_c = total_c+c_len;
            NR_REW_mmn(trial,:,unit) = NR_concat_rew_mmn(unit,total_r+1:total_r+r_len);
            total_r = total_r+r_len;
        end
    end
    
    cue_location = 81; rew_location = 81;
    %% separate into Pre/Post after zscore - prepare for noise correlation by subtracting PSTH
    
    for unit = 1:unit_number
        for trial = 1:R_trials
            Pre_CUE_mmn_R_trial{unit}(:,trial) = R_CUE_mmn(trial,1:cue_location,unit);
            Post_CUE_mmn_R_trial{unit}(:,trial) = R_CUE_mmn(trial,101:c_len,unit); %101 is bin starting with 501
            
            Pre_REW_mmn_R_trial{unit}(:,trial) = R_REW_mmn(trial,1:rew_location,unit);
            Post_REW_mmn_R_trial{unit}(:,trial) = R_REW_mmn(trial,101:r_len,unit);
        end
        for trial = 1:NR_trials
            Pre_CUE_mmn_NR_trial{unit}(:,trial) = NR_CUE_mmn(trial,1:cue_location,unit);
            Post_CUE_mmn_NR_trial{unit}(:,trial) = NR_CUE_mmn(trial,101:c_len,unit); %101 is bin starting with 501
            
            Pre_REW_mmn_NR_trial{unit}(:,trial) = NR_REW_mmn(trial,1:rew_location,unit);
            Post_REW_mmn_NR_trial{unit}(:,trial) = NR_REW_mmn(trial,101:r_len,unit);
        end
    end
    
    for unit = 1:unit_number
        for bin = 1:length(Pre_CUE_mmn_R_trial{unit}(:,1))
            Pre_CUE_mmn_R_noise{unit}(bin,:) = Pre_CUE_mmn_R_trial{unit}(bin,:) ...
                - mean(Pre_CUE_mmn_R_trial{unit}(bin,:));
            Pre_CUE_mmn_NR_noise{unit}(bin,:) = Pre_CUE_mmn_NR_trial{unit}(bin,:) ...
                - mean(Pre_CUE_mmn_NR_trial{unit}(bin,:));
        end
        
        for bin = 1:length(Post_CUE_mmn_R_trial{unit}(:,1))
            Post_CUE_mmn_R_noise{unit}(bin,:) = Post_CUE_mmn_R_trial{unit}(bin,:) ...
                - mean(Post_CUE_mmn_R_trial{unit}(bin,:));
            Post_CUE_mmn_NR_noise{unit}(bin,:) = Post_CUE_mmn_NR_trial{unit}(bin,:) ...
                - mean(Post_CUE_mmn_NR_trial{unit}(bin,:));
        end
        
        for bin = 1:length(Pre_REW_mmn_R_trial{unit}(:,1))
            Pre_REW_mmn_R_noise{unit}(bin,:) = Pre_REW_mmn_R_trial{unit}(bin,:) ...
                - mean(Pre_REW_mmn_R_trial{unit}(bin,:));
            Pre_REW_mmn_NR_noise{unit}(bin,:) = Pre_REW_mmn_NR_trial{unit}(bin,:) ...
                - mean(Pre_REW_mmn_NR_trial{unit}(bin,:));
        end
        for bin = 1:length(Post_REW_mmn_R_trial{unit}(:,1))
            Post_REW_mmn_R_noise{unit}(bin,:) = Post_REW_mmn_R_trial{unit}(bin,:) ...
                - mean(Post_REW_mmn_R_trial{unit}(bin,:));
            Post_REW_mmn_NR_noise{unit}(bin,:) = Post_REW_mmn_NR_trial{unit}(bin,:) ...
                - mean(Post_REW_mmn_NR_trial{unit}(bin,:));
        end
    end
    
    
    %% concatenate for single corr coeff
    Post_REW_mmn_NR=[];
    for unit = 1:unit_number
        Pre_CUE_mmn_R(:,unit) = reshape(Pre_CUE_mmn_R_noise{unit},size(Pre_CUE_mmn_R_noise{unit},1)*size(Pre_CUE_mmn_R_noise{unit},2),1);
        Post_CUE_mmn_R(:,unit) = reshape(Post_CUE_mmn_R_noise{unit},size(Post_CUE_mmn_R_noise{unit},1)*size(Post_CUE_mmn_R_noise{unit},2),1);
        Pre_REW_mmn_R(:,unit) = reshape(Pre_REW_mmn_R_noise{unit},size(Pre_REW_mmn_R_noise{unit},1)*size(Pre_REW_mmn_R_noise{unit},2),1);
        Post_REW_mmn_R(:,unit) = reshape(Post_REW_mmn_R_noise{unit},size(Post_REW_mmn_R_noise{unit},1)*size(Post_REW_mmn_R_noise{unit},2),1);
        
        Pre_CUE_mmn_NR(:,unit) = reshape(Pre_CUE_mmn_NR_noise{unit},size(Pre_CUE_mmn_NR_noise{unit},1)*size(Pre_CUE_mmn_NR_noise{unit},2),1);
        Post_CUE_mmn_NR(:,unit) = reshape(Post_CUE_mmn_NR_noise{unit},size(Post_CUE_mmn_NR_noise{unit},1)*size(Post_CUE_mmn_NR_noise{unit},2),1);
        Pre_REW_mmn_NR(:,unit) = reshape(Pre_REW_mmn_NR_noise{unit},size(Pre_REW_mmn_NR_noise{unit},1)*size(Pre_REW_mmn_NR_noise{unit},2),1);
        Post_REW_mmn_NR(:,unit) = reshape(Post_REW_mmn_NR_noise{unit},size(Post_REW_mmn_NR_noise{unit},1)*size(Post_REW_mmn_NR_noise{unit},2),1);
    end
    
    
    %% CORR
    %concatenated corr with indexing
    
    [Corr.Cue_Pre_R,Pval.Cue_Pre_R] = corr(Pre_CUE_mmn_R,Pre_CUE_mmn_R);
    [Corr.Cue_Pre_NR,Pval.Cue_Pre_NR] = corr(Pre_CUE_mmn_NR,Pre_CUE_mmn_NR);
    
    [Corr.Cue_Post_R,Pval.Cue_Post_R] = corr(Post_CUE_mmn_R,Post_CUE_mmn_R);
    [Corr.Cue_Post_NR,Pval.Cue_Post_NR] = corr(Post_CUE_mmn_NR,Post_CUE_mmn_NR);
    
    [Corr.Rew_Pre_R,Pval.Rew_Pre_R] = corr(Pre_REW_mmn_R,Pre_REW_mmn_R);
    [Corr.Rew_Pre_NR,Pval.Rew_Pre_NR] = corr(Pre_REW_mmn_NR,Pre_REW_mmn_NR);
    
    [Corr.Rew_Post_R,Pval.Rew_Post_R] = corr(Post_REW_mmn_R,Post_REW_mmn_R);
    [Corr.Rew_Post_NR,Pval.Rew_Post_NR] = corr(Post_REW_mmn_NR,Post_REW_mmn_NR);
    
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
    disp(['Finished with Session ' num2str(fn)])
end

%% Save data for further analysis

F = FileName{1,fn};
filename = extractAfter(F, 'Extracted_');
monkey_id = extractBefore(filename,'_2015');
save([monkey_id '_Corr_index'], 'Corr_INDEX')