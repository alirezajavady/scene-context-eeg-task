function [im, imnames] = load_SceObj_images(directory_im)
% LOAD_SCEOBJ_IMAGES  Load the scene/object stimuli.
%
% Each object has five files in <category>/level_1/:
%   <Object>_Scene.png       intact scene with the object
%   <Object>_Scene_b.png     intact scene without the object
%   <Object>_Scramble.png    scrambled scene with the object
%   <Object>_Scramble_b.png  scrambled scene without the object
%   <Object>_S.png           not used by the task
%
% Outputs (one column/row per stimulus, 100 in total):
%   im{1,n}       background + object (grayscale, 576 x 1024)
%   im{2,n}       background only
%   imnames{n,1}  [category, level, condition], condition 1 = scene, 2 = scramble
%   imnames{n,2}  file name, used to look up the object trigger
%
% 5 categories x 5 objects x 2 conditions = 50 stimuli, loaded twice so
% that every stimulus is shown twice per run.

numImgs = 5*5*2*2;

im = cell(1,numImgs);
imnames = cell(numImgs,1);

imcounter = 0;

categories = {'food', 'electronics', 'container', 'office_supply','home_decore'};
levels = {'level_1'};

%% load images
countcond = 0;
while countcond < 2
    countcond = countcond + 1;
    for i = 1:length(categories)
        for j = 1:length(levels)
            imPath = [directory_im categories{i} filesep levels{j} filesep];
            imdir = dir([imPath '*.png']);

            for k = 1:5:(length(imdir)-1)
                imintact = []; imscram = [];
                for kk = 1:5

                    imname = char(imdir(k+kk-1).name);
                    imtemp = imread([imPath imname]);
                    imtemp = imresize(imtemp,[576,1024]);

                    imname = char(strcat('asdfghjk',imname)); % To ensure the length is enough
                    if strcmp(imname(end-5:end), '_S.png')
                        continue
                    end
                    if strcmp(imname(end-11:end), '_Scene_b.png')
                        imtemp = rgb2gray(imtemp);
                        imintact{2} = imtemp;
                    elseif strcmp(imname(end-9:end),'_Scene.png')
                        imtemp = rgb2gray(imtemp);
                        imintact{1} = imtemp;
                    end
                    if strcmp(imname(end-14:end), '_Scramble_b.png')
                        imtemp = rgb2gray(imtemp);
                        imscram{2} = imtemp;
                    elseif strcmp(imname(end-12:end),'_Scramble.png')
                        imtemp = rgb2gray(imtemp);
                        imscram{1} = imtemp;
                    end

                end
                imcounter = imcounter + 1;
                im{1,imcounter} = imintact{1};
                im{2,imcounter} = imintact{2};
                imnames{imcounter,1} = [i, j, 1];
                imnames{imcounter,2} = imname(9:end);

                imcounter = imcounter + 1;
                im{1,imcounter} = imscram{1};
                im{2,imcounter} = imscram{2};
                imnames{imcounter,1} = [i, j, 2];
                imnames{imcounter,2} = imname(9:end);

            end
        end
    end
end
