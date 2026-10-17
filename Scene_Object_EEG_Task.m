% SCENE_OBJECT_EEG_TASK  Object categorization in scene context (EEG).
%
% On every trial a background (an intact or a scrambled scene) is shown, a
% target object is flashed inside it for 80 ms, and the background stays on
% screen afterwards. After every 1-5 trials a response screen asks the
% participant to report the category of the last object with the keyboard.
% Event codes are sent to the EEG amplifier through a serial trigger box.
%
% See README.md for the trial timeline, trigger codes and output format.

clear all
if exist('instrreset', 'file'), instrreset; end % close serial ports left open by a previous session

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
filename = fullfile(resultsDir, [subjID '_Behavioral_Scene_Object_' nowstring '.csv']);
fileID = fopen(filename, 'w');
header = 'Trail Number,Run Number,Correctness,Category,Cat_Answer,Response Time (ms),TrialOnSetTime,Level,WithOrWithout Scene,Image Name\n';
fprintf(fileID, header);

%% load images
directory_im = [fullfile(mainPATH, 'stimuli', 'images') filesep];
[imgs, imgNames] = load_SceObj_images(directory_im);

%% initialize triggers
if p.usetrigs
    a = serial(p.triggerPort, 'BaudRate', p.triggerBaudRate, 'DataBits', 8);
    fopen(a);
    fwrite(a, 0);
else
    a = []; % no trigger box (e.g. for piloting the task on a laptop)
end

send_trigger(p, a, 55) % start of experiment

%% send instructions to subject
instruction_text;
im_instruction = imread(fullfile(mainPATH, 'stimuli', 'instructions', 'response_2.png'));

%% make the presentation sequence (one random order of the 100 images per run)
generate_random_seq_and_save
nImages = length(im_sequence); % number of images shown per run

%% show the stimuli
nRun = 15;
totalImgs_PerRun = 100;

run = 1;
expstart = tic;
correctTrialsPerRun = 0;
total_trialsPerRun = 0;
indq = 0;

while run < nRun + 1
    send_trigger(p, a, 30) % start of run
    for i = 1:totalImgs_PerRun

        disp(['Run ' num2str(run) ', image ' num2str(i) ' out of ' num2str(nImages)]);

        % image onset
        trialOnSetTime = toc(expstart);
        ttr = tic;

        [~, ~, stim_s_onset] = image_display(p, a, imgs{2,im_sequence(run,i)}, imgs{1,im_sequence(run,i)}, imgNames{im_sequence(run,i),1}, imgNames{im_sequence(run,i),2});

        while toc(ttr) < p.trialduration
        end

        % ======= the response screen follows every 1-5 trials
        indq = indq + 1;
        if indq == 1
            probabilities = [0.05, 0.15, 0.25, 0.30, 0.25];
            rndq = randsample(1:5, 1, true, probabilities); % weighted random selection
        end

        % values written for trials without a response screen
        correctness = -2;
        cat_answer = -2;
        response_time = -0.002;
        perform_trigger = 60; % non-question trial

        category = imgNames{im_sequence(run,i),1}(1);
        level = imgNames{im_sequence(run,i),1}(2);
        WOrWiScene = imgNames{im_sequence(run,i),1}(3);
        imname = imgNames{im_sequence(run,i),2};

        if indq == rndq
            indq = 0;

            send_trigger(p, a, 59) % response screen onset
            [correctness, cat_answer, response_time] = button_response(p.waitresponsetime, category, p, a, stim_s_onset, im_instruction);

            total_trialsPerRun = total_trialsPerRun + 1;
            if correctness == 1
                disp('correct');
                correctTrialsPerRun = correctTrialsPerRun + 1;
                perform_trigger = 63; % correct trial
            elseif correctness == -1
                disp('missed');
                perform_trigger = 61; % missed trial
            elseif correctness == 0
                disp('wrong');
                perform_trigger = 62; % wrong trial
            end
        end

        send_trigger(p, a, perform_trigger)
        trial_data_str = sprintf('%d,%d,%d,%d,%d,%2f,%4f,%d,%d,%s,\n', i, run, correctness, category, cat_answer, response_time*1000, trialOnSetTime, level, WOrWiScene, imname);
        fprintf(fileID, '%s', trial_data_str);

        % ======= break between runs
        if mod(i, totalImgs_PerRun) == 0

            send_trigger(p, a, 50) % end of run

            % reset the font size
            Screen('TextSize', p.whandle, p.text_size);

            runteller = sprintf('Run %d out of %d ', run, nRun);
            n = length(runteller);
            Screen('DrawText', p.whandle, runteller, p.xCenter-n/2*p.text_size/1.7, p.yCenter-250 - p.text_size * 1.5, [255 255 255]);

            % the same encouraging message is shown whatever the performance
            performance = ceil(correctTrialsPerRun/total_trialsPerRun * 100);
            str = sprintf('You performed very well ( %d%% )! Keep up the good work!', performance);
            n = length(str);
            Screen('DrawText', p.whandle, str, p.xCenter-n/2*p.text_size/1.7, p.yCenter-250, [255 255 255]);

            str = 'After 10 sec you can press any button to continue the experiment...';
            wtime = 10;
            n = length(str);
            Screen('DrawText', p.whandle, str, p.xCenter-n/2*p.text_size/1.7, p.yCenter+220, [255 255 255]);
            Screen('Flip', p.whandle);

            % wait for any key
            WaitSecs(wtime);
            KbWait;

            run = run + 1;
            correctTrialsPerRun = 0;
            total_trialsPerRun = 0;
        end
    end
end

%% cleanup at the end of the experiment
fclose(fileID);

sca;
ShowCursor;
ListenChar(0);
Priority(0);

% release the serial port
clear a
