function [ Population ] = NewPopulation( net, NumPop )
%UNTITLED9 Summary of this function goes here
%   takes in a Neural Network and a population size
%   outputs a population of NN weights of the same size
Population = cell(NumPop,1);
for i = 1:NumPop
    genes = cell(3,1);
    genes{1} = rand(size(net.IW{1}));
    genes{2} = rand(size(net.LW{2,1}));
    genes{3} = rand(size(net.LW{3,2}));
    Population{i} = genes;
end

end

