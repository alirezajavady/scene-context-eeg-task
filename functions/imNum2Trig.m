function [condTrigger,stimTrigger] = imNum2Trig(imgName, ObjName)
% IMNUM2TRIG  Trigger codes for one stimulus.
%
%   condTrigger  background type: 25 + (level-1)*2 + condition
%                26 = level 1 scene, 27 = level 1 scramble,
%                28 = level 2 scene, 29 = level 2 scramble
%   stimTrigger  object identity, 1-25 (index in AllObjNames)

AllObjNames = {'Bowl', 'Jar', 'Kettle', 'Mug', 'ShoulderBag',...
    'Headset', 'Laptop', 'Microwave', 'Toaster', 'Vacuum',...
    'Apple', 'BagOfChips', 'Banana', 'CanOfSoda', 'Watermelon',...
    'Mirror', 'Picture', 'Statue', 'Vase', 'WallClock',...
    'Folder', 'Marker', 'Pencil', 'Ruler', 'Stapler'};

img_name = char(ObjName);

underline_detector = regexp(img_name,'_');
first_img_name = img_name(1:underline_detector(1)-1);

level = imgName(2);
SceneScramble = imgName(3);

stimTrigger = find(strcmpi(first_img_name, AllObjNames));
condTrigger = 25 + ((level - 1) * 2 + (SceneScramble));

end % end function
