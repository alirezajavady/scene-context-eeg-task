function [im, imnames ]= load_images(directory,filetype)
% LOAD_IMAGES  Load the training images (grayscale, 360 x 640).
%
%   im{n}         image
%   imnames{n,1}  category, read from the first character of the file name
%                 (1 food, 2 electronics, 3 container, 4 office supply,
%                 5 home decor)
%   imnames{n,2}  file name

files = dir(directory);

im = [];imnames=[];
for i = 1:length(files)
    if strfind(files(i).name,filetype)
        imtemp = imread([directory filesep files(i).name]);
        imtemp = imresize(imtemp,[360,640]);
        if size(imtemp,3)==3
            imtemp = rgb2gray(imtemp);
        end
        im{end+1} = imtemp;

        %%save category number
        cat_num=str2num(files(i).name(1));
        imnames{end+1,1}=cat_num;

        %%save file name
        imnames{end,2}=files(i).name;
    end
end
