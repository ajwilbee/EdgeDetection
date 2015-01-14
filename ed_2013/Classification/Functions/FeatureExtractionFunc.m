function [ output ] = FeatureExtractionFunc( ImageFilePath)
%UNTITLED5 Summary of this function goes here
%   ImageFilePath - the path to a folder which contains all of the images
%   which are to be used for training

    depthPyramids = 9;
    %ImageFilePaths = {'C:\Users\ajw4388\Pictures\abbey'};%;'C:\Users\ajw4388\Pictures\bedroom';'C:\Users\ajw4388\Pictures\kitchen';'C:\Users\ajw4388\Pictures\playground'};

        addpath(ImageFilePath);

    direction = 'reduce';

    % FeatureSet
    % ValidationData
    % TestingData
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

    close all

        ImageFiles = dir(fullfile(ImageFilePath, '*.jpg'));

        gistfinal = cell(length(ImageFiles),1);
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
                gistfinal{j} = [gist1;gist2;gist3;gist4]; %every column is a different image/sample    
            end
        end
        emptyCells = cellfun(@isempty,gistfinal);
        gistfinal(emptyCells) = [];


   
       gistfinal = cell2mat(gistfinal'); 
     

    trueclass = ones(size(gistfinal,2),1);
    


    output = {gistfinal,trueclass};
end

