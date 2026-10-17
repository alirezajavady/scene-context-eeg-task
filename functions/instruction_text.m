% INSTRUCTION_TEXT  Show the key-mapping instructions and wait for a key
% press (script; assumes the screen has been initialized).

im_instruction = imread(fullfile(mainPATH, 'stimuli', 'instructions', 'response.png'));

% draw image to backbuffer
imtex = Screen('MakeTexture', p.whandle, im_instruction);

imheight = size(im_instruction,1);
imwidth = size(im_instruction,2);

Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter-imwidth/2,p.yCenter-imheight/2,p.xCenter+imwidth/2,p.yCenter+imheight/2]);
Screen('Close', imtex);
Screen('Flip', p.whandle);

% wait for any key
WaitSecs(1);
KbWait;
