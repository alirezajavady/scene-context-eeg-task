% EXPERIMENT_PARAMETERS  Display, timing, trigger and key settings (script).

%% display
p.text_size = 22;
p.text_font = 'Times New Roman';
p.fixationColor = [255 0 0];

%% trial timing (seconds)
p.trialduration = 2.5;      % fixation + scene + object + scene
p.fixation = 1.5;           % fixation cross
p.sceneDurBefore = 0.5;     % scene without target object
p.objectDur = 0.08;         % scene + target object
p.sceneDurAfter = 0.42;     % scene without target object
p.waitresponsetime = 1.5;   % maximum waiting time for subject response

%% triggers (serial trigger box)
p.usetrigs = 1;                  % 0 = run without a trigger box
p.triggerPort = '/dev/ttyUSB0';  % e.g. 'COM3' on Windows
p.triggerBaudRate = 57600;

%% buttons
KbName('UnifyKeyNames');

p.quitkey = KbName('q');
p.pause = KbName('p');
p.continue = KbName('c');

p.f = KbName('f'); % food
p.s = KbName('s'); % electronics
p.j = KbName('j'); % containers
p.k = KbName('k'); % office supply
p.l = KbName('l'); % home decor
