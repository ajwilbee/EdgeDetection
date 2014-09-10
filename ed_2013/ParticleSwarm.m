function [best_vectors] = ParticleSwarm(imgGrey, imgGT, coef, iteration, parameters)
n=size(imgGrey,1);
m=size(imgGrey,2);
image=zeros(n,m);
imagedetected=cell(size(parameters,1),1);
for k=1:size(parameters,1)
    imagedetected{k}=image;
end

[best_vectors] = myPSO(imgGrey, imgGT,coef,iteration,parameters)
end




