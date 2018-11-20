clear; close all; clc

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

%% Concatenating Session Data

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
N.PostRew = length(PostRew_NR_list);

PostRew_R_list = [];
for s = 1:session_number
    temp_data = [];
    temp_data(:,:) = Corr_INDEX(s).postrew_R_list;
    PostRew_R_list = [PostRew_R_list;temp_data];
end

%% Positive Correlations Location Index

pos_temp.pre_cue_NR = find(PreCue_NR_list > 0);
pos_temp.pre_cue_R = find(PreCue_R_list > 0);
pos_temp.post_cue_NR = find(PostCue_NR_list > 0);
pos_temp.post_cue_R = find(PostCue_R_list > 0);

pos_temp.pre_rew_NR = find(PreRew_NR_list > 0);
pos_temp.pre_rew_R = find(PreRew_R_list > 0);
pos_temp.post_rew_NR = find(PostRew_NR_list > 0);
pos_temp.post_rew_R = find(PostRew_R_list > 0);

%% Positive Correlations Index

pos_IND.pre_cue_NR = PreCue_NR_list(pos_temp.pre_cue_NR,1);
pos_IND.pre_cue_R = PreCue_R_list(pos_temp.pre_cue_R,1);
pos_IND.post_cue_NR = PostCue_NR_list(pos_temp.post_cue_NR,1);
pos_IND.post_cue_R = PostCue_R_list(pos_temp.post_cue_R,1);

pos_IND.pre_rew_NR = PreRew_NR_list(pos_temp.pre_rew_NR,1);
pos_IND.pre_rew_R = PreRew_R_list(pos_temp.pre_rew_R,1);
pos_IND.post_rew_NR = PostRew_NR_list(pos_temp.post_rew_NR,1);
pos_IND.post_rew_R = PostRew_R_list(pos_temp.post_rew_R,1);

%% Negative Correlations Location Index

neg_temp.pre_cue_NR = find(PreCue_NR_list < 0);
neg_temp.pre_cue_R = find(PreCue_R_list < 0);
neg_temp.post_cue_NR = find(PostCue_NR_list < 0);
neg_temp.post_cue_R = find(PostCue_R_list < 0);

neg_temp.pre_rew_NR = find(PreRew_NR_list < 0);
neg_temp.pre_rew_R = find(PreRew_R_list < 0);
neg_temp.post_rew_NR = find(PostRew_NR_list < 0);
neg_temp.post_rew_R = find(PostRew_R_list < 0);

%% Positive Correlations Index

neg_IND.pre_cue_NR = PreCue_NR_list(neg_temp.pre_cue_NR,1);
neg_IND.pre_cue_R = PreCue_R_list(neg_temp.pre_cue_R,1);
neg_IND.post_cue_NR = PostCue_NR_list(neg_temp.post_cue_NR,1);
neg_IND.post_cue_R = PostCue_R_list(neg_temp.post_cue_R,1);

neg_IND.pre_rew_NR = PreRew_NR_list(neg_temp.pre_rew_NR,1);
neg_IND.pre_rew_R = PreRew_R_list(neg_temp.pre_rew_R,1);
neg_IND.post_rew_NR = PostRew_NR_list(neg_temp.post_rew_NR,1);
neg_IND.post_rew_R = PostRew_R_list(neg_temp.post_rew_R,1);

%% Plotting Histogramfigure

figure
h_R = [];h_NR = [];
subplot(1,2,1)
h_R = histogram(neg_IND.pre_cue_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(neg_IND.pre_cue_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(neg_IND.pre_cue_R) median(neg_IND.pre_cue_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(neg_IND.pre_cue_NR) median(neg_IND.pre_cue_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(neg_IND.pre_cue_R),3));
txt2 = num2str(round(median(neg_IND.pre_cue_NR),3));
text((x1(1)+.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','right')
text((x1(1)+.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','right')
ylabel('Unit-Pairs')
if ranksum(neg_IND.pre_cue_R,neg_IND.pre_cue_NR,'tail','left') < 0.05
    if ranksum(neg_IND.pre_cue_R,neg_IND.pre_cue_NR,'tail','left') < 0.01
        if ranksum(neg_IND.pre_cue_R,neg_IND.pre_cue_NR,'tail','left') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if ranksum(neg_IND.pre_cue_R,neg_IND.pre_cue_NR,'tail','right') < 0.05
    if ranksum(neg_IND.pre_cue_R,neg_IND.pre_cue_NR,'tail','right') < 0.01
        if ranksum(neg_IND.pre_cue_R,neg_IND.pre_cue_NR,'tail','right') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

subplot(1,2,2)
h_R = [];h_NR = [];
h_R = histogram(pos_IND.pre_cue_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(pos_IND.pre_cue_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(pos_IND.pre_cue_R) median(pos_IND.pre_cue_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(pos_IND.pre_cue_NR) median(pos_IND.pre_cue_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(pos_IND.pre_cue_R),3));
txt2 = num2str(round(median(pos_IND.pre_cue_NR),3));
text((x1(2)-.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','left')
text((x1(2)-.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','left')
if ranksum(pos_IND.pre_cue_R,pos_IND.pre_cue_NR,'tail','left') < 0.05
    if ranksum(pos_IND.pre_cue_R,pos_IND.pre_cue_NR,'tail','left') < 0.01
        if ranksum(pos_IND.pre_cue_R,pos_IND.pre_cue_NR,'tail','left') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end
if ranksum(pos_IND.pre_cue_R,pos_IND.pre_cue_NR,'tail','right') < 0.05
    if ranksum(pos_IND.pre_cue_R,pos_IND.pre_cue_NR,'tail','right') < 0.01
        if ranksum(pos_IND.pre_cue_R,pos_IND.pre_cue_NR,'tail','right') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end
sgtitle(['Precue Correlation of ' monkey_name])


figure
h_R = [];h_NR = [];
subplot(1,2,1)
h_R = histogram(neg_IND.post_cue_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(neg_IND.post_cue_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(neg_IND.post_cue_R) median(neg_IND.post_cue_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(neg_IND.post_cue_NR) median(neg_IND.post_cue_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(neg_IND.post_cue_R),3));
txt2 = num2str(round(median(neg_IND.post_cue_NR),3));
text((x1(1)+.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','right')
text((x1(1)+.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','right')
ylabel('Unit-Pairs')
if ranksum(neg_IND.post_cue_R,neg_IND.post_cue_NR,'tail','left') < 0.05
    if ranksum(neg_IND.post_cue_R,neg_IND.post_cue_NR,'tail','left') < 0.01
        if ranksum(neg_IND.post_cue_R,neg_IND.post_cue_NR,'tail','left') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if ranksum(neg_IND.post_cue_R,neg_IND.post_cue_NR,'tail','right') < 0.05
    if ranksum(neg_IND.post_cue_R,neg_IND.post_cue_NR,'tail','right') < 0.01
        if ranksum(neg_IND.post_cue_R,neg_IND.post_cue_NR,'tail','right') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

subplot(1,2,2)
h_R = [];h_NR = [];
h_R = histogram(pos_IND.post_cue_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(pos_IND.post_cue_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(pos_IND.post_cue_R) median(pos_IND.post_cue_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(pos_IND.post_cue_NR) median(pos_IND.post_cue_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(pos_IND.post_cue_R),3));
txt2 = num2str(round(median(pos_IND.post_cue_NR),3));
text((x1(2)-.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','left')
text((x1(2)-.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','left')
if ranksum(pos_IND.post_cue_R,pos_IND.post_cue_NR,'tail','left') < 0.05
    if ranksum(pos_IND.post_cue_R,pos_IND.post_cue_NR,'tail','left') < 0.01
        if ranksum(pos_IND.post_cue_R,pos_IND.post_cue_NR,'tail','left') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if ranksum(pos_IND.post_cue_R,pos_IND.pre_cue_NR,'tail','right') < 0.05
    if ranksum(pos_IND.post_cue_R,pos_IND.pre_cue_NR,'tail','right') < 0.01
        if ranksum(pos_IND.post_cue_R,pos_IND.pre_cue_NR,'tail','right') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

sgtitle(['Postcue Correlation of ' monkey_name])


figure
h_R = [];h_NR = [];
subplot(1,2,1)
h_R = histogram(neg_IND.pre_rew_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(neg_IND.pre_rew_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(neg_IND.pre_rew_R) median(neg_IND.pre_rew_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(neg_IND.pre_rew_NR) median(neg_IND.pre_rew_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(neg_IND.pre_rew_R),3));
txt2 = num2str(round(median(neg_IND.pre_rew_NR),3));
text((x1(1)+.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','right')
text((x1(1)+.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','right')
ylabel('Unit-Pairs')
if ranksum(neg_IND.pre_rew_R,neg_IND.pre_rew_NR,'tail','left') < 0.05
    if ranksum(neg_IND.pre_rew_R,neg_IND.pre_rew_NR,'tail','left') < 0.01
        if ranksum(neg_IND.pre_rew_R,neg_IND.pre_rew_NR,'tail','left') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if ranksum(neg_IND.pre_rew_R,neg_IND.pre_rew_NR,'tail','right') < 0.05
    if ranksum(neg_IND.pre_rew_R,neg_IND.pre_rew_NR,'tail','right') < 0.01
        if ranksum(neg_IND.pre_rew_R,neg_IND.pre_rew_NR,'tail','right') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

subplot(1,2,2)
h_R = [];h_NR = [];
h_R = histogram(pos_IND.pre_rew_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(pos_IND.pre_rew_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(pos_IND.pre_rew_R) median(pos_IND.pre_rew_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(pos_IND.pre_rew_NR) median(pos_IND.pre_rew_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(pos_IND.pre_rew_R),3));
txt2 = num2str(round(median(pos_IND.pre_rew_NR),3));
text((x1(2)-.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','left')
text((x1(2)-.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','left')
if ranksum(pos_IND.pre_rew_R,pos_IND.pre_rew_NR,'tail','left') < 0.05
    if ranksum(pos_IND.pre_rew_R,pos_IND.pre_rew_NR,'tail','left') < 0.01
        if ranksum(pos_IND.pre_rew_R,pos_IND.pre_rew_NR,'tail','left') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if ranksum(pos_IND.pre_rew_R,pos_IND.pre_cue_NR,'tail','right') < 0.05
    if ranksum(pos_IND.pre_rew_R,pos_IND.pre_cue_NR,'tail','right') < 0.01
        if ranksum(pos_IND.pre_rew_R,pos_IND.pre_cue_NR,'tail','right') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

sgtitle(['Prerew Correlation of ' monkey_name])


figure
h_R = [];h_NR = [];
subplot(1,2,1)
h_R = histogram(neg_IND.post_rew_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(neg_IND.post_rew_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(neg_IND.post_rew_R) median(neg_IND.post_rew_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(neg_IND.post_rew_NR) median(neg_IND.post_rew_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(neg_IND.post_rew_R),3));
txt2 = num2str(round(median(neg_IND.post_rew_NR),3));
text((x1(1)+.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','right')
text((x1(1)+.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','right')
ylabel('Unit-Pairs')
if ranksum(neg_IND.post_rew_R,neg_IND.post_rew_NR,'tail','left') < 0.05
    if ranksum(neg_IND.post_rew_R,neg_IND.post_rew_NR,'tail','left') < 0.01
        if ranksum(neg_IND.post_rew_R,neg_IND.post_rew_NR,'tail','left') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if ranksum(neg_IND.post_rew_R,neg_IND.post_rew_NR,'tail','right') < 0.05
    if ranksum(neg_IND.post_rew_R,neg_IND.post_rew_NR,'tail','right') < 0.01
        if ranksum(neg_IND.post_rew_R,neg_IND.post_rew_NR,'tail','right') < 0.001
            str = '***';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(-0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

subplot(1,2,2)
h_R = [];h_NR = [];
h_R = histogram(pos_IND.post_rew_R,'BinWidth',0.05,'FaceColor','r');
hold on
h_NR = histogram(pos_IND.post_rew_NR,'BinWidth',0.05,'FaceColor','b');
y1 = ylim;
x1 = xlim;
line([median(pos_IND.post_rew_R) median(pos_IND.post_rew_R)], [0 y1(2)], ...
    'Color','r','LineStyle','--')
line([median(pos_IND.post_rew_NR) median(pos_IND.post_rew_NR)], [0 y1(2)], ...
    'Color','b','LineStyle','--')
txt1 = num2str(round(median(pos_IND.post_rew_R),3));
txt2 = num2str(round(median(pos_IND.post_rew_NR),3));
text((x1(2)-.2),(y1(2)-200),txt1,'Color','r','HorizontalAlignment','left')
text((x1(2)-.2),(y1(2)-400),txt2,'Color','b','HorizontalAlignment','left')
if ranksum(pos_IND.post_rew_R,pos_IND.post_rew_NR,'tail','left') < 0.05
    if ranksum(pos_IND.post_rew_R,pos_IND.post_rew_NR,'tail','left') < 0.01
        if ranksum(pos_IND.post_rew_R,pos_IND.post_rew_NR,'tail','left') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','b','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

if ranksum(pos_IND.post_rew_R,pos_IND.pre_cue_NR,'tail','right') < 0.05
    if ranksum(pos_IND.post_rew_R,pos_IND.pre_cue_NR,'tail','right') < 0.01
        if ranksum(pos_IND.post_rew_R,pos_IND.pre_cue_NR,'tail','right') < 0.001
            str = '***';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        else
            str = '**';
            text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
        end
    else
        str = '*';
        text(0.4,y1(2)-100,str,'Color','r','FontSize',11,'FontWeight','bold','FontName', 'Arial');
    end
end

sgtitle(['Postrew Correlation of ' monkey_name])