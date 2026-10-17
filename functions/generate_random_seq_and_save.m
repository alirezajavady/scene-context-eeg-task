% GENERATE_RANDOM_SEQ_AND_SAVE  One random order of the 100 stimuli for
% each of the 15 runs (script). im_sequence(run, trial) indexes into the
% stimuli returned by load_SceObj_images.

rng('shuffle'); %seeds the random number generator based on the current time.

for run = 1:15 % run number
    im_sequence(run, :) = randperm(100);
end

% save the sequence of images
% filename = sprintf('%s_SequenceData.mat', subjID);
% save(filename, 'im_sequence');
