% SCENE_OBJECT_EEG_TRAIN  Practice session, run before the EEG task.
%
% The 25 objects of the main task are shown alone on a plain background
% (12 views per object, 300 images, random order). Each image is flashed
% for 80 ms and every trial is followed by the response screen, so the
% participant learns the category keys. No triggers are sent.
%
% See README.md for the trial timeline and output format.

clear all;

%% set current path
mainPATH = fileparts(mfilename('fullpath'));
if isempty(mainPATH), mainPATH = pwd; end
cd(mainPATH);
addpath(fullfile(mainPATH, 'functions'));

%% parameters of the experiment
experiment_parameters;

%% experiment preamble (all initialization code)
initialization_script;

%% Create a new file for saving results
resultsDir = fullfile(mainPATH, 'results');
if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end
filename = fullfile(resultsDir, [subjID '_Behavioral_Train_sixcat_' nowstring '.csv']);
fileID = fopen(filename, 'w');
header = 'Trail Number,Correctness,Category, Cat_Answer,Response Time (ms),TrialOnSetTime, Image Name\n';
fprintf(fileID, header);

%% load images
directory_im = fullfile(mainPATH, 'stimuli', 'train_images');
[imgs, imgNames] = load_images(directory_im, 'png');

%% make the presentation sequence
im_sequence = randperm(length(imgs));
nImages = length(im_sequence);

%% send instructions to subject
instruction_text;
im_instruction = imread(fullfile(mainPATH, 'stimuli', 'instructions', 'response_2.png'));

%% show the stimuli
expstart = tic;
for i = 1:nImages

    disp([num2str(i) ' out of ' num2str(nImages)]);

    % image onset
    trialOnSetTime = toc(expstart);
    [stim_onset] = image_display_train(p, imgs{im_sequence(i)});

    % show response page and wait
    category = imgNames{im_sequence(i),1};
    [correctness, cat_answer, response_time] = button_response_train(p.waitresponsetime, category, p, stim_onset, im_instruction);
    imname = imgNames{im_sequence(i),2};

    if correctness == 1
        disp('correct');
    elseif correctness == -1
        disp('missed');
    elseif correctness == 0
        disp('wrong');
    end

    trial_data_str = sprintf('%d,%d,%d,%d,%2f,%4f,%s\n', i, correctness, category, cat_answer, response_time*1000, trialOnSetTime, imname);
    fprintf(fileID, '%s', trial_data_str);

end

%% cleanup at the end of the experiment
fclose(fileID);
Screen('CloseAll');
Priority(0);
