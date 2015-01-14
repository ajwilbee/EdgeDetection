function [ Morientation ] = OrientationChannel( channel, Orientation,Scales,gb )
%ORIENTATION Summary of this function goes here
%   create the orienation channel
Morientation = cell(Scales*length(Orientation),1);
lambda  = 8;
psi     = [0 pi/2];
gamma   = 0.5;
bw      = 1;
counter = 1;
for i = 1:length(Orientation)
    
   for j = 1:Scales
        image = channel{j}(:,:,1);%only works on grey scale
        
         Morientation{counter} = imfilter(image, gb{i}, 'symmetric');
         counter = counter +1;
%          figure;
%          imshow(Morientation{counter});
   end    
end

end

