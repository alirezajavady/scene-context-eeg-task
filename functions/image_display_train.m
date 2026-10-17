function [stim_s_onset] = image_display_train(p,im_s)
% IMAGE_DISPLAY_TRAIN  Show one training trial: fixation, object, blank.
%
% Returns a tic handle taken at the onset of the blank screen that follows
% the object (response times are measured from it).

plot_fixation_cross(p,1,p.fixationColor);
WaitSecs(p.fixation+p.sceneDurBefore);

% draw image to backbuffer
imtex = Screen('MakeTexture', p.whandle, im_s);
imheight = size(im_s,1);
imwidth = size(im_s,2);

Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter-imwidth/2,p.yCenter-imheight/2,p.xCenter+imwidth/2,p.yCenter+imheight/2]);
Screen('Close', imtex);

stim_so_onset = tic;
Screen('Flip', p.whandle);

while toc(stim_so_onset)< p.objectDur
end

% blank screen
stim_s_onset = tic;
Screen('Flip', p.whandle);

while toc(stim_s_onset)< p.sceneDurAfter
end
