function [ Pyramids,RedChannel,GreenChannel,BlueChannel,YellowChannel,IntensityChannel ] = ChannelCreation(im, depthPyramids,direction )
%CHANNELCREATION Summary of this function goes here
%   creates a color channel for processing in scene recognition
%   depthPyramids = how many layers the pyramid will have including the
%   base
%   direction = the direction of the pyramid, 'reduce' or 'expand'
%   im = the original image that the color channel is being made for
%   
%   return: Pyramids = a cell containing levels of the image pyramid
Pyramids = cell(depthPyramids,1);
RedChannel = cell(depthPyramids,1);
GreenChannel = cell(depthPyramids,1);
BlueChannel= cell(depthPyramids,1);
YellowChannel= cell(depthPyramids,1);
IntensityChannel= cell(depthPyramids,1);
Pyramids{1} = im;

for i = 2:depthPyramids
    Pyramids{i} = impyramid(Pyramids{i-1}, direction);   
end
for i = 1:depthPyramids
    RedChannel{i} = Pyramids{i}(:,:,1)-(Pyramids{i}(:,:,2)+Pyramids{i}(:,:,3))/2;
    GreenChannel{i} = Pyramids{i}(:,:,2)-(Pyramids{i}(:,:,1)+Pyramids{i}(:,:,3))/2;
    BlueChannel{i} =Pyramids{i}(:,:,3)-(Pyramids{i}(:,:,1)+Pyramids{i}(:,:,2))/2;
    YellowChannel{i} =Pyramids{i}(:,:,1)+Pyramids{i}(:,:,2)-2*(abs(Pyramids{i}(:,:,1)-Pyramids{i}(:,:,2))+Pyramids{i}(:,:,3));
    IntensityChannel{i} =(Pyramids{i}(:,:,1)+Pyramids{i}(:,:,2)+Pyramids{i}(:,:,3))/3;
end

end

