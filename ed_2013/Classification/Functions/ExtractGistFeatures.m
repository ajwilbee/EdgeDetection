function [ Features, trueclass ] = ExtractGistFeatures( ImageFilePaths )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%   output: 
%   Features: the features of the image that have been extracted
%   reducedDim = reduced Feature vector
%   W = premultiplication feature reduction multiplier
%   reducedDim = W*temp
close all
depthPyramids = 9;
%ImageFilePaths = {'C:\Users\ajw4388\Pictures\abbey';'C:\Users\ajw4388\Pictures\bedroom';'C:\Users\ajw4388\Pictures\kitchen';'C:\Users\ajw4388\Pictures\playground'};
for i = 1: length(ImageFilePaths)
    addpath(ImageFilePaths{i});
end
direction = 'reduce';
CenterSurroundFineMin = 3;
CenterSurroundFineMax = 5;
CenterSurroundCourseDistance = [3,4];%must be a scalar
InterpolationFilter = [1,1]/2; %this can be adjusted for better results in the future
Orientation = [3*pi/4,pi/2,pi/4,0];
gb = cell(length(Orientation),1);
Scales = 4;
lambda  = 8;
psi     = [0 pi/2];
gamma   = 0.5;
bw      = 1;
for i = 1: length(Orientation)
    gb{i} = gabor_fn(bw,gamma,psi(1),lambda,Orientation(i))+ 1i * gabor_fn(bw,gamma,psi(2),lambda,Orientation(i));
end
gistfinal = cell(length(ImageFilePaths),1);
for i =1:length(ImageFilePaths)
    ImageFiles = dir(fullfile(ImageFilePaths{i}, '*.jpg'));
    
    gistfinal{i} = cell(length(ImageFiles),1);
    for j = 1:length(ImageFiles)
        im = imread(ImageFiles(j).name);
        if(size(im,3) == 3)
            [ Pyramids,RedChannel,GreenChannel,BlueChannel,YellowChannel,IntensityChannel ] = ChannelCreation(im, depthPyramids,direction );
            [ RG,BY,I ] = CenterSurround( RedChannel,GreenChannel,BlueChannel,YellowChannel,IntensityChannel, CenterSurroundFineMax, CenterSurroundFineMin, CenterSurroundCourseDistance );
            MOChannel = OrientationChannel( Pyramids, Orientation,Scales,gb );
            NumSquaresPerSide = 4;
            [ gist1 ] = SumSubRegions(RG, NumSquaresPerSide );
            [ gist2 ] = SumSubRegions(BY, NumSquaresPerSide );
            [ gist3 ] = SumSubRegions(I, NumSquaresPerSide );
            [ gist4 ] = SumSubRegions(MOChannel, NumSquaresPerSide );
            gist4 = real(gist4); % should i keep the imaginary part? not likely
            gistfinal{i}{j} = [gist1,gist2,gist3,gist4]; %every column is a different image/sample    
        end
    end
    emptyCells = cellfun(@isempty,gistfinal{i,1});
    gistfinal{i,1}(emptyCells) = [];
end

for i =1:length(gistfinal)
   gistfinal{i,1} = cell2mat(gistfinal{i,1}'); 
end
Features = gistfinal{1};

for i = 2 : length(gistfinal)
    Features = cat(2,Features,gistfinal{i});
end

trueclass = ones(size(gistfinal{1},2),1);
for i = 2 : length(gistfinal)
    trueclass = cat(1,trueclass,i*ones(size(gistfinal{i},2),1));
end








end

