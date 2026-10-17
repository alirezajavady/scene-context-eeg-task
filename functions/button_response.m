function [correctness,cat_answer, answer_time] = button_response(time,correct_answer,params, a, stim_onset,im_instruction)
% BUTTON_RESPONSE  Show the response screen and wait up to `time` seconds
% for a category key (S, F, J, K, L). correctness: 1 correct, 0 wrong,
% -1 no answer. answer_time is measured from stim_onset (the scene shown
% after the object). P opens the pause page, Q closes the screen.

% response triggers are sent in the code
p = params;

correctness = -1;
cat_answer=0;
answer_time=0;
%wait for key
keyIsDown = 0;
% draw image to backbuffer
imtex = Screen('MakeTexture', p.whandle, im_instruction);

imheight = size(im_instruction,1);
imwidth = size(im_instruction,2);

Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter-imwidth/2,p.yCenter-imheight/2,p.xCenter+imwidth/2,p.yCenter+imheight/2]);
Screen('Close', imtex);

Instruction_onset = tic;
Screen('Flip', p.whandle);


tic;

while toc(Instruction_onset) < time
 
    [keyIsDown, secs, key, deltaSecs] = KbCheck();
    
    if keyIsDown ~=0 %if key pressed
        
        if  key(p.f) == 1% 
            send_trigger(p, a,  45)
            cat_answer=1;
            answer_time=toc(stim_onset);
          
            if  correct_answer == 1 % food
                correctness = 1;
                
            else
                correctness = 0;
            end 
    
        elseif  key(p.s) == 1  % electronic
            send_trigger(p, a,  45)
            cat_answer=2;
            answer_time=toc(stim_onset);
                
            if  correct_answer == 2 
                correctness = 1;
            else
                correctness = 0;
            end 

        elseif   key(p.j) == 1 % containers
            send_trigger(p, a,  45)
            cat_answer=3;
            answer_time=toc(stim_onset);

            if  correct_answer == 3
                correctness = 1;
            else
                correctness = 0;
            end 
            
        elseif  key(p.k) == 1 % office supply
            send_trigger(p, a,  45)
            cat_answer=4;
            answer_time=toc(stim_onset);
                 
            if  correct_answer == 4 % office supply
                correctness = 1;
            else
                correctness = 0;
            end 
            
        elseif  key(p.l) == 1 % home decor
            send_trigger(p, a,  45)
            cat_answer=5;
            answer_time=toc(stim_onset);
                 
            if  correct_answer == 5  
                correctness = 1;
            else
                correctness = 0;
            end 

        elseif key(p.pause) % 
            showContinuePage;
            break;
        elseif key(p.quitkey) %Q key
            sca
            return
        end
        
        break
        
    end
    
end


%wait for remainder time
while toc < time
end

