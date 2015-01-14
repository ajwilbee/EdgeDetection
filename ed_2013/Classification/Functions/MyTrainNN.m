function [ net ] = MyTrainNN( reducedDim, trueclass )
%UNTITLED4 Summary of this function goes here
%   Traom the NN
%   reducedDim = the feature vector set after it has gone through PCA or
%   ICA or Both
%   TargetMatrix n x numclasses matrix which has a 1 if that is a correct
%   classification
    TargetMatrix = zeros(max(trueclass),length(trueclass));

    for i = 1:length(trueclass)
        TargetMatrix(trueclass(i),i) = 1;
    end
     net = patternnet([200,100]);%,'trainbr','crossentropy');
     net = train(net,reducedDim,TargetMatrix);
end

