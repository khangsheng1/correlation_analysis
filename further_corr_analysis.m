%% Further analysis of correlation data from corr_analysis

clear all; close all; clc

%% Find and load saved data set

[FileName, pathname] = uigetfile('*.mat', 'Select the MATLAB code file',...
    'MultiSelect', 'on');
trial_number = length(FileName);

cd ../..
cd (pathname)

load(FileName)

monkey_label = extractBefore(FileName,'_');
if str2num(monkey_label) == 0059
    monkey_name = 'Soph';
elseif str2num(monkey_label) == 504
    monkey_name = 'PG';
else
    disp('Select correct DatDir files')
end

session_number = size(Corr_INDEX,1);

PreCue_NR_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).precue_NR_list;
    PreCue_NR_list = [PreCue_NR_list;temp_data];
end
N.PreCue = length(PreCue_NR_list);

PreCue_R_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).precue_R_list;
    PreCue_R_list = [PreCue_R_list;temp_data];
end

PostCue_NR_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).postcue_NR_list;
    PostCue_NR_list = [PostCue_NR_list;temp_data];
end
N.PostCue = length(PostCue_NR_list);

PostCue_R_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).postcue_R_list;
    PostCue_R_list = [PostCue_R_list;temp_data];
end

PreRew_NR_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).prerew_NR_list;
    PreRew_NR_list = [PreRew_NR_list;temp_data];
end
N.PreRew = length(PreRew_NR_list);

PreRew_R_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).prerew_R_list;
    PreRew_R_list = [PreRew_R_list;temp_data];
end

PostRew_NR_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).postrew_NR_list;
    PostRew_NR_list = [PostRew_NR_list;temp_data];
end

PostRew_R_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).postrew_R_list;
    PostRew_R_list = [PostRew_R_list;temp_data];
end
%% Plotting section

figure
subplot(1,4,1)
x = 1:length(PreCue_NR_list);
y1 = sort(PreCue_NR_list);
y2 = sort(PreCue_R_list);
plot(x,y1,'b',x,y2,'r','LineWidth',1)
ylim([-1 1])
xlim([-250 length(PreCue_NR_list)+500])
title('Pre Cue')
ylabel('Correlation Coefficient')
xlabel('Unit-Pair')
xticks([])

if signrank(PreCue_R_list,PreCue_NR_list,'tail','left') < .05
    if signrank(PreCue_R_list,PreCue_NR_list,'tail','left') < .01
        if signrank(PreCue_R_list,PreCue_NR_list,'tail','left') < .001
            str = '***';
            text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if signrank(PreCue_R_list,PreCue_NR_list,'tail','right') < .05
    if signrank(PreCue_R_list,PreCue_NR_list,'tail','right') < .01
        if signrank(PreCue_R_list,PreCue_NR_list,'tail','right') < .001
            str = '***';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

subplot(1,4,2)
x = 1:length(PostCue_NR_list);
y1 = sort(PostCue_NR_list);
y2 = sort(PostCue_R_list);
plot(x,y1,'b',x,y2,'r','LineWidth',1)
ylim([-1 1])
xlim([-250 length(PostCue_NR_list)+500])
title('Post Cue')
xlabel('Unit-Pair')
xticks([])

if signrank(PostCue_R_list,PostCue_NR_list,'tail','left') < .05
    if signrank(PostCue_R_list,PostCue_NR_list,'tail','left') < .01
        if signrank(PostCue_R_list,PostCue_NR_list,'tail','left') < .001
            str = '***';
            text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if signrank(PostCue_R_list,PostCue_NR_list,'tail','right') < .05
    if signrank(PostCue_R_list,PostCue_NR_list,'tail','right') < .01
        if signrank(PostCue_R_list,PostCue_NR_list,'tail','right') < .001
            str = '***';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

subplot(1,4,3)
x = 1:length(PreRew_NR_list);
y1 = sort(PreRew_NR_list);
y2 = sort(PreRew_R_list);
plot(x,y1,'b',x,y2,'r','LineWidth',1)
ylim([-1 1])
xlim([-250 length(PreRew_NR_list)+500])
title('Pre Rew')
xlabel('Unit-Pair')
xticks([])

if signrank(PreRew_R_list,PreRew_NR_list,'tail','left') < .05
    if signrank(PreRew_R_list,PreRew_NR_list,'tail','left') < .01
        if signrank(PreRew_R_list,PreRew_NR_list,'tail','left') < .001
            str = '***';
            text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if signrank(PreRew_R_list,PreRew_NR_list,'tail','right') < .05
    if signrank(PreRew_R_list,PreRew_NR_list,'tail','right') < .01
        if signrank(PreRew_R_list,PreRew_NR_list,'tail','right') < .001
            str = '***';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

subplot(1,4,4)
x = 1:length(PostRew_NR_list);
y1 = sort(PostRew_NR_list);
y2 = sort(PostRew_R_list);
plot(x,y1,'b',x,y2,'r','LineWidth',1)
ylim([-1 1])
xlim([-250 length(PostRew_NR_list)+500])
title('Post Rew')
xlabel('Unit-Pair')
xticks([])

if signrank(PostRew_R_list,PostRew_NR_list,'tail','left') < .05
    if signrank(PostRew_R_list,PostRew_NR_list,'tail','left') < .01
        if signrank(PostRew_R_list,PostRew_NR_list,'tail','left') < .001
            str = '***';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if signrank(PostRew_R_list,PostRew_NR_list,'tail','right') < .05
    if signrank(PostRew_R_list,PostRew_NR_list,'tail','right') < .01
        if signrank(PostRew_R_list,PostRew_NR_list,'tail','right') < .001
            str = '***';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(5000,.8,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

sgtitle(['Sorted Correlation for ' monkey_name])

%% Visualizing Mean correlation between NR and R
%
% PreCue_NR = nanmean(PreCue_NR_list);
% err_PreCue_NR = [max(PreCue_NR) min(PreCue_NR)];
%
% PreCue_R = nanmean(PreCue_NR_list);
% err_PreCue_R = [max(PreCue_R) min(PreCue_R)];
%
% PostCue_NR = nanmean(PreCue_NR_list);
% err_PostCue_NR = [max(PostCue_NR) min(PostCue_NR)];
%
% PostCue_R = nanmean(PreCue_NR_list);
% err_PostCue_R = [max(PostCue_R) min(PostCue_R)];
%
% PreRew_NR = nanmean(PreCue_NR_list);
% err_PreRew_NR = [max(PreRew_NR) min(PreRew_NR)];
%
% PreRew_R = nanmean(PreCue_NR_list);
% err_PreRew_R = [max(PreRew_R) min(PreRew_R)];
%
% PostRew_NR = nanmean(PreCue_NR_list);
% err_PostRew_NR = [max(PostRew_NR) min(PostRew_NR)];
%
% PostRew_R = nanmean(PreCue_NR_list);
% err_PostRew_R = [max(PostRew_R) min(PostRew_R)];
%
% NR = [PreCue_NR, PostCue_NR, ...
%     PreRew_NR,PostRew_NR];
% R = [PreCue_R, PostCue_R, ...
%     PreRew_R,PostRew_R];
% x = 1:4;
% figure
% errorbar(x,NR,)
% hold on
% plot(R)
% set(gca,'XTickLabel',{'Pre Cue',' ','Post Cue',' ','Pre Rew',' ','Post Rew'})
%
% ylim([-0.01 0.01])
% line([1 4],[0,0])