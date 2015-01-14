function [ Fitness,Index ] = Fitness( Population )
%UNTITLED10 Summary of this function goes here
%   takes the population and performs a fitness calculation
%   returns the sorted fitness with the index to the original ordering
    NumPop = length(Population);
    Fitness = zeros(NumPop,1);
    for i = 1:NumPop
        net.IW(1) = Population{i}(1);
        net.LW(2,1) = Population{i}(2);
        net.LW(3,2) = Population{i}(3);
        Classification = net(FeatureSet');
        Fitness(i) = perform(net,Classification',GroundTruth');
        [Fitness, Index] = sort(Fitness,'descend');
    end
end

