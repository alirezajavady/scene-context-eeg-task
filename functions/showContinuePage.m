% SHOWCONTINUEPAGE  Pause screen, shown when P is pressed on the response
% screen; the task continues when C is pressed. Script run from inside
% button_response, so p and a are in scope.

WaitSecs(uniform(0.1,0.2));
Wait_trigger = 201;

str = 'press C to continue!';
qMark_size = 70;
Screen('TextSize', p.whandle, qMark_size);
Screen('DrawText', p.whandle, str, p.xCenter, p.yCenter, [255 255 255]);
Screen('Flip', p.whandle);

% send pause trigger
send_trigger(p, a, Wait_trigger);

% wait for 'c' to be pressed
while 1
    [keyIsDown, secs, key, deltaSecs] = KbCheck();
    if keyIsDown ~= 0 && key(p.continue) == 1
        break;
    end
end
