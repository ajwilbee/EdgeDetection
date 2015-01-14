% takes the file folder where the folders of images are contained and saves
% the extracted features to another folder

% FeatureFileCreator takes a folder path to the folder which contains many folders of images. each of the folders should contain only one class of images. 
% The code will create for each folder an output cell which containes two elements. the first element is the 544xnumber of image gist feature matrix, the second is the 1xnumber of image classification vector
% this is all ones, and as such needs to be scaled in the second part of the program to get the proper end class for training.
% 
% The benefit of this method is that the features need only be extracted once for each set so that training can be done more quickly and with different class combinations easily.

inputDir = 'C:\Users\ajw4388\Pictures\IndStudy'; %file directory which contains the folders which contain all the images
outputfileLocation = 'C:\Users\ajw4388\Documents\MATLAB\IndependantStudy\CorrectedFeatures';
imageDirs = dir(fullfile(inputDir));
for x = 3:length(imageDirs)
    Features = FeatureExtractionFunc([inputDir '\' imageDirs(x).name]);
   % Features = 0;
    save([outputfileLocation '\' imageDirs(x).name]  ,'Features');% imageDirs(x).name
    
end