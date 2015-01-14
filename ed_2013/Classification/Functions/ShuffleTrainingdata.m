function [ reducedDim ,trueclass] = ShuffleTrainingdata( reducedDim,trueclass )
%UNTITLED3 Summary of this function goes here
%   reducedDim = the feature vector set after it has gone through PCA or
%   ICA or Both
%   trueclass = the known class that the image belongs to
%   Rearranges the training data so that the training matrix is not skewed
%   for proper training

shuffle = randperm(size(reducedDim,2));
reducedDim= reducedDim(:,shuffle);
trueclass = trueclass(shuffle);
end

