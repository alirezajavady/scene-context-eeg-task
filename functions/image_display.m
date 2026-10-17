function [condTrigger, stimtrigger, stim_s_onset] = image_display(p, a, im_s, im_so, imgName, objNames)
% IMAGE_DISPLAY  Show one trial: fixation, scene, scene + object, scene.
%
%   im_s      background only (scene or scrambled scene)
%   im_so     background with the target object
%   imgName   [category, level, condition] of the stimulus
%   objNames  file name of the stimulus (gives the object identity)
%
% Returns the two triggers sent and a tic handle taken at the onset of the
% scene that follows the object (response times are measured from it).

% Initial fixation
send_trigger(p, a, 35); % fixation trigger = 35
plot_fixation_cross(p, 1, p.fixationColor, 1);
WaitSecs(p.fixation);

% -------------------- 1. Show scene image BEFORE object --------------------
[condTrigger, stimtrigger] = imNum2Trig(imgName, objNames);

imtex = Screen('MakeTexture', p.whandle, im_s);
[imheight, imwidth, ~] = size(im_s);

send_trigger(p, a, condTrigger); % background type (26 scene, 27 scramble)

Screen('DrawTexture', p.whandle, imtex, [], ...
    [p.xCenter - imwidth/2, p.yCenter - imheight/2, ...
     p.xCenter + imwidth/2, p.yCenter + imheight/2]);
Screen('Close', imtex);

ts = tic;
Screen('Flip', p.whandle);

while toc(ts) < p.sceneDurBefore
end

% -------------------- 2. Show OBJECT image --------------------
imtex = Screen('MakeTexture', p.whandle, im_so);
send_trigger(p, a, stimtrigger); % object identity (1-25)
Screen('DrawTexture', p.whandle, imtex, [], ...
    [p.xCenter - imwidth/2, p.yCenter - imheight/2, ...
     p.xCenter + imwidth/2, p.yCenter + imheight/2]);
Screen('Close', imtex);

Screen('Flip', p.whandle);

WaitSecs(p.objectDur);

% -------------------- 3. Show scene image AFTER object --------------------
imtex = Screen('MakeTexture', p.whandle, im_s);
Screen('DrawTexture', p.whandle, imtex, [], ...
    [p.xCenter - imwidth/2, p.yCenter - imheight/2, ...
     p.xCenter + imwidth/2, p.yCenter + imheight/2]);
Screen('Close', imtex);

stim_s_onset = tic;
Screen('Flip', p.whandle);

while toc(stim_s_onset) < p.sceneDurAfter
end

end
