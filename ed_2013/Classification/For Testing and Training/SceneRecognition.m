inputDir = 'C:\Users\ajw4388\Documents\MATLAB\IndependantStudy\CorrectedFeatures\Mixture'; % folder containing all of the outputs from FeatureFileCreator that are to be classified using the same network
imageDirs = dir(fullfile(inputDir));
filename = 'MixedPCABackPropagation'; % output file name
divider = 1;%percentage of images to use
load([inputDir '\' imageDirs(3).name ]);
    temp = Features;
    AllFeatures = temp{1}(1:end,1:round(end/divider));
    AllTargets =  temp{2}(1:round(end/divider))';
count = 2;
for x = 4:length(imageDirs)
  
    load([inputDir '\' imageDirs(x).name ]);
    temp = Features;
    AllFeatures = [AllFeatures temp{1}(1:end,1:round(end/divider))];
    AllTargets = [AllTargets temp{2}(1:round(end/divider))'*count];
    count = count +1;
end


%Feature reduction and train
% loads in previously computed feature sets (features x samples)
% these sets come in as 2 x 1 cell were the first object is a feature set
% and the other is the expected classification
% performs ICA and PCA on them
% the featuer reduced set will then be trained in a veriety of manners

%need to concatinate the feature sets then

% [E, D] = pcamat(AllFeatures,1,544-400);
% [nv, wm, dwm] = whitenv(AllFeatures, E, D);
% [A, W] = fpica(nv, wm, dwm);
[Z, W, E, mVal,mVar]=myPCA(AllFeatures',.99);
meanMat = ones(size(AllFeatures'))*diag(mVal);
reducedFeatures = ((AllFeatures'-meanMat)*W)';
% save([filename '_Features'], 'reducedFeatures')
% save([filename '_Target'], 'AllTargets')
% save([filename '_ICACoeffecient'], 'W')
% save([filename '_All'])
[ reducedFeatures ,trueclass] = ShuffleTrainingdata( reducedFeatures,AllTargets );

TargetMatrix = zeros(max(trueclass),length(trueclass));
for i = 1:length(trueclass)
    TargetMatrix(trueclass(i),i) = 1;
end
LayerSize1 = [10 10 20 20 50 50 100 100];
Layersize2 = [1 20  1  40 1 100 1 200 ]
for i = 1: length(LayerSize1)
    if Layersize2(i) == 1
        LayerSize = [LayerSize1(i)];
    else
        LayerSize = [LayerSize1(i) Layersize2(i)];

    end
net = TrainNNGA(LayerSize,reducedFeatures,TargetMatrix);

%  net = feedforwardnet(LayerSize);
%  net = train(net,reducedFeatures,TargetMatrix);
 

%  net = patternnet(LayerSize,'trainscg','crossentropy');
%  net = train(net,reducedFeatures,TargetMatrix);
 
 output = net(reducedFeatures);

 performance = perform(net, output,TargetMatrix);
 plotconfusion(TargetMatrix, output);
 save([filename , int2str(LayerSize1(i)), ' ' int2str(Layersize2(i)), '_All'])
end