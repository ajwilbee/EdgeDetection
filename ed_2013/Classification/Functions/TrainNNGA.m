function [ net ] = TrainNNGA( LayerSize,Inputs,Targets )

% LayerSize - the size of each layer as an array [10, 10] is a 2 hidden
%   layer matrix of size 10
% Inputs- the matrix of inputs with the features as rows and each column is
% a sample
% Targets - the binary matrix of targets, each row is a class and each
% column indicates that samples membership to the class 1 for inclusion
%
% outputs:
% net- the trained NN
net = feedforwardnet(LayerSize);
% configure the neural network for this dataset
net = configure(net, Inputs, Targets);
% create handle to the MSE_TEST function, that
% calculates MSE
h = @(x) mse_test(x, net, Inputs, Targets);
% Setting the Genetic Algorithms tolerance for
% minimum change in fitness function before
% terminating algorithm to 1e-8 and displaying
% each iteration's results.
ga_opts = gaoptimset('TolFun', 1e-8,'display','iter');
% PLEASE NOTE: For a feed-forward network
% with n neurons, 3n+1 quantities are required
% in the weights and biases column vector.
%
% a. n for the input weights
% b. n for the input biases
% c. n for the output weights
% d. 1 for the output bias
% running the genetic algorithm with desired options
genes = net.numweightElements;
[x_ga_opt, err_ga] = ga(h, genes, ga_opts);
net = setwb(net, x_ga_opt');
y = net(Inputs);
perf = perform(net,Targets,y);
[percentMissClassified, confusionMatrix, ind, percentages] = confusion(Targets,y);
end

