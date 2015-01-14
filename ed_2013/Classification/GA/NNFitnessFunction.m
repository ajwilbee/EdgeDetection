function fitness = NNFitnessFunction(genes)
%% for every GA test on all different data currently need to set the input, output lengths and layer size to match
% also need to include the data set
% http://radio.feld.cvut.cz/matlab/toolbox/nnet/adv1212.html
%http://www.mathworks.com/matlabcentral/answers/100323-how-can-i-use-the-genetic-algorithm-ga-to-train-a-neural-network-in-neural-network-toolbox-6-0-3
inputlength = 2;
outputlength = 4;
LayerSize = [10,10];
net = patternnet(LayerSize);
load('C:\Users\ajw4388\Documents\MATLAB\IndependantStudy\GA\mysimpleclassTarget.mat')
load('C:\Users\ajw4388\Documents\MATLAB\IndependantStudy\GA\mysimpleclassInputs.mat')
net = configure(net,simpleclassInputs,simpleclassTargets);

test = net.numweightElements;
IW = net.IW;
LW = net.LW;
B = net.b;
%genes = zeros(inputlength*LayerSize(1)+outputlength*LayerSize(end)+totalHLGenes + sum(LayerSize)+outputlength,1);
index = 1;
%% fill the NN
for i=1:size(net.IW,1)
   
       temp = net.IW{i};
       
       if(~isempty(temp))
           for row = 1:size(temp,1)
               net.IW{i}(row,:) = genes(index:index + inputlength-1);
               index = index + size(temp,2);
           end
       end
IW{i}-net.IW{i}
   
end
for i=1:size(net.LW,1)
   for j=1:size(net.LW,2) 
       temp = net.LW{i,j};
       if(~isempty(temp))
           for row = 1:size(temp,1)
               net.LW{i,j}(row,:)  =genes(index:index + size(temp,2)-1);
               index = index + size(temp,2);
           end
       end
    LW{i,j} - net.LW{i,j}
   end
end

for i = 1:length(net.b)
    temp = net.b{i};
   net.b{i} = genes(index:index + size(temp,1)-1);
    index = index + size(temp,1);
    B{i} - net.b{i}
end 

output = net(simpleclassInputs);
[m,I] = max(simpleclassTargets);
[m2,I2] = max(output);
%error = 1-abs(length(I)/(sum(I==I2)+eps));
fitness = sum(I==I2);

end

