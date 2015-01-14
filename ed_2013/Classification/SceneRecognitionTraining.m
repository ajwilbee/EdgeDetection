function [ W mVal net] = SceneRecognitionTraining( inputDir, outputfileLocation, filename )
%UNTITLED4 Summary of this function goes here
% inputDir -> file directory which contains the folders which contain all
% the images each folder has only one class of images
% outputfileLocation -> the location where all feature matrix will be
% stored
% filename -> location where the final training state will be stored
%
% W -> PCA transformation matrix for feature reduction
% mVal -> mean value for PCA normalization
% net -> classification neural network
%   Detailed explanation goes here

inputDir = 'C:\Users\ajw4388\Pictures\IndStudy'; %
outputfileLocation = 'C:\Users\ajw4388\Documents\MATLAB\IndependantStudy\CorrectedFeatures';
filename = 'MixedPCABackPropagation'; % output file name
imageDirs = dir(fullfile(inputDir));
temp = FeatureExtractionFunc([inputDir '\' imageDirs(3).name]);
AllFeatures = temp{1}(1:end,1:round(end/divider));
AllTargets =  temp{2}(1:round(end/divider))';
count = 2;
for x = 4:length(imageDirs)
    temp = FeatureExtractionFunc([inputDir '\' imageDirs(x).name]);
   % Features = 0;
    save([outputfileLocation '\' imageDirs(x).name]  ,'Features');% imageDirs(x).name
    AllFeatures = [AllFeatures temp{1}(1:end,1:round(end/divider))];
    AllTargets = [AllTargets temp{2}(1:round(end/divider))'*count];
    count = count +1;
end

[Z, W, E, mVal,mVar]=myPCA(AllFeatures',.99);
meanMat = ones(size(AllFeatures'))*diag(mVal);
reducedFeatures = ((AllFeatures'-meanMat)*W)';

[ reducedFeatures ,trueclass] = ShuffleTrainingdata( reducedFeatures,AllTargets );

TargetMatrix = zeros(max(trueclass),length(trueclass));
for i = 1:length(trueclass)
    TargetMatrix(trueclass(i),i) = 1;
end
LayerSize = 50;
 

net = TrainNNGA(LayerSize,reducedFeatures,TargetMatrix);

%  net = feedforwardnet(LayerSize);
%  net = train(net,reducedFeatures,TargetMatrix);
 

%  net = patternnet(LayerSize,'trainscg','crossentropy');
%  net = train(net,reducedFeatures,TargetMatrix);
 
 output = net(reducedFeatures);

 performance = perform(net, output,TargetMatrix);
 plotconfusion(TargetMatrix, output);
 save([filename ,'_All'])
end

