function [reducedDim,W ] = ICAFeatureReduction( Features )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%   Input: 
%   Features: the feature vectors that need to have their dimensionality
%   reduced, every column is a different sample
%   Output:
%   reducedDim = reduced Feature vector
%   W = premultiplication feature reduction multiplier
%   reducedDim = W*temp

[E, D] = pcamat( Features);
[nv, wm, dwm] = whitenv( Features, E, D);
[A, W] = fpica(nv, wm, dwm);

reducedDim = W*Features;
end

