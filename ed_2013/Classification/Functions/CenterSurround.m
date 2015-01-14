function [ RG,BY,I ] = CenterSurround( RedChannel,GreenChannel,BlueChannel,YellowChannel,IntensityChannel, CenterSurroundFineMax, CenterSurroundFineMin, CenterSurroundCourseDistance )
%CENTERSURROUND Summary of this function goes here
%   Performs a center surround subtraction by interpolating a coarse image
%   to the same size as a finer image (some work is needed to get the
%   pixels to line up perfectly) and then subtracting the coarse image from
%   the fine image and taking the absolute value of the subtraction this
%   results in a lighting invariant set from which color features can be
%   extracted.
%
%   center surround is anothe way to say laplacian of gaussian.
%
%   input:
%   Channel = a pyramid of gausian smoothed images
%   CenterSurroundFineMax = the max level of "fine" image in the pyramid 
%   CenterSurroundFineMin = the min level of "fine" image in the pyramid 
%   CenterSurroundCourseDistance = an array of the depth disances for the
%   course image with repect to the fine image
%
%   output:
%   M = a cell of all the centersurround images

RG = cell((CenterSurroundFineMax-CenterSurroundFineMin+1)*length(CenterSurroundCourseDistance),1);
BY = cell((CenterSurroundFineMax-CenterSurroundFineMin+1)*length(CenterSurroundCourseDistance),1);
I = cell((CenterSurroundFineMax-CenterSurroundFineMin+1)*length(CenterSurroundCourseDistance),1);
counter = 1;
for i = CenterSurroundFineMin:CenterSurroundFineMax   
    for j = 1:length(CenterSurroundCourseDistance)
        fineRG =  RedChannel{i}-GreenChannel{i};
        fineBY = BlueChannel{i}-YellowChannel{i};
        fineI = IntensityChannel{i};
        coarseRG = RedChannel{i+CenterSurroundCourseDistance(j)}-GreenChannel{i+CenterSurroundCourseDistance(j)};
        coarseBY = BlueChannel{i+CenterSurroundCourseDistance(j)}-YellowChannel{i+CenterSurroundCourseDistance(j)};
        coarseI = IntensityChannel{i+CenterSurroundCourseDistance(j)};
        RG{counter} = CenterSurroundOperation( fineRG,coarseRG,CenterSurroundCourseDistance(j) );
        BY{counter} = CenterSurroundOperation( fineBY,coarseBY,CenterSurroundCourseDistance(j) );
        I{counter} = CenterSurroundOperation( fineI ,coarseI,CenterSurroundCourseDistance(j) );
        counter = counter +1;
%         figure
%         imshow( RG{counter})
%                 figure
%         imshow(BY{counter})
%                 figure
%         imshow(I{counter})
    end
end


end

