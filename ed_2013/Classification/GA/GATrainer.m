inputlength = 2;
outputlength = 4;
LayerSize = [10,10];
totalHLGenes = 0;
for i = 1:length(LayerSize)-1
   totalHLGenes = totalHLGenes+LayerSize(i) * LayerSize(i+1);
end
net = patternnet(LayerSize);
net = train(net,simpleclassInputs,simpleclassTargets);
test = net.numweightElements;
genes = zeros(inputlength*LayerSize(1)+outputlength*LayerSize(end)+totalHLGenes + sum(LayerSize)+outputlength,1);
index = 1;
for i=1:size(net.IW,1)
   
       temp = net.IW{i};
       if(~isempty(temp))
           for row = 1:size(temp,1)
               genes(index:index + size(temp,2)-1) = temp(row,:);
               index = index + size(temp,2);
           end
       end
  
end
for i=1:size(net.LW,1)
   for j=1:size(net.LW,2) 
       temp = net.LW{i,j};
       if(~isempty(temp))
           for row = 1:size(temp,1)
               genes(index:index + size(temp,2)-1) = temp(row,:);
               index = index + size(temp,2);
           end
       end
   end
end
for i = 1:length(net.b)
    temp = net.b{i};
    genes(index:index + size(temp,1)-1) = temp;
    index = index + size(temp,1);
end 
fitness = NNFitnessFunction(genes);
% testIW = net.IW;
% testLW = net.LW;
% testB = net.b;
% index = 1;
% for i=1:size(net.IW,1)
%    
%        temp = net.IW{i};
%        if(~isempty(temp))
%            for row = 1:size(temp,1)
%                net.IW{i}(row,:) = genes(index:index + size(temp,2)-1);
%                index = index + size(temp,2);
%            end
%        end
% 
%    
% end
% for i=1:size(net.LW,1)
%    for j=1:size(net.LW,2) 
%        temp = net.LW{i,j};
%        if(~isempty(temp))
%            for row = 1:size(temp,1)
%                net.LW{i,j}(row,:)  =genes(index:index + size(temp,2)-1);
%                index = index + size(temp,2);
%            end
%        end
% 
%    end
% end
% 
% for i = 1:length(net.b)
%     temp = net.b{i};
%    net.b{i} = genes(index:index + size(temp,1)-1);
%     index = index + size(temp,1);
%     
% end 