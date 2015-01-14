function [ M ] = CenterSurroundOperation( Fine,Coarse,DepthDistance )
%CENTERSURROUNDOPERATION Summary of this function goes here
%   Detailed explanation goes here

        

        for k = 1:DepthDistance
            Coarse = impyramid(Coarse,'expand');
        end
        [r,c,d] = size(Fine);
        [rt,ct,dt]= size(Coarse);
        temp = padarray(Coarse,[r-rt,c-ct],'replicate','pre');
        M = abs(Fine-temp);
        
end

