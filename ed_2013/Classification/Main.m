inputDir = 'C:\Users\ajw4388\Pictures\IndStudy'; %file directory which contains the folders which contain all the images
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
