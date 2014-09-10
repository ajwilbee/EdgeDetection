%% PSO for CA_Fuzzy Edge Detection

%% main.m, mpPSO.m, fit_ness.m, maskCA.m
%% 10/10/2013 2013 Edge Detection çal??mas? tamamland?.
close all
%clear all
clc
%%
ImageFilesPath = 'C:\Users\ajw4388\Documents\Thesis\BSR\BSDS500\data\images\test';
GroundTruthFilesPath = 'C:\Users\ajw4388\Documents\Thesis\BSR\BSDS500\data\groundTruth\test';
ImageSaveFolderName = 'PSO_AllImages'; % make this ahead of time
ImageSaveFolder = [pwd '\' ImageSaveFolderName];
mkdir(ImageSaveFolder);

addpath(ImageFilesPath,GroundTruthFilesPath);
ImageFiles = dir(fullfile(ImageFilesPath, '*.jpg'));
GroundTruthFiles = dir(fullfile(GroundTruthFilesPath, '*.mat'));

%%
iteration =100;
%starting point for PSO: 1-> division offset 2-> fuzzy boundery 3-> CA rule
parameters = [60 0.3 23;79 1 124; 105 0 321; 23 0.3 452;78 0.01 35;92 0.6 326;73 0.43 168;86 0.87 245; 112 0.54 410;124 0.67 203;
              51 0.23 123;69 0.89 24; 101 0.34 121; 39 0.4 45;71 0.19 355;97 0.73 56;134 0.3 18;35 0.71 45;68 0.47 386;82 0.712 178;];
          
size(parameters);
c1 =2.01;
c2 = 2.01;
[row,col] = size (im1);
coef =[.73 c1 c2];
%dbstop in fit_ness
%% 

 for i=1:length(ImageFiles)
     
    imFullName =ImageFiles(i).name(1:end-4);
    im = imread(ImageFiles(i).name);
    imgGrey =double(rgb2gray(im));
    load(GroundTruthFiles(i).name);
    imgGT = double(groundTruth{1}.Boundaries);
    mkdir(ImageSaveFolderName,imFullName);
    imwrite(im,strcat([ImageSaveFolder '\' imFullName '\'],'Original.jpg'));
    imwrite(groundTruth{1}.Boundaries,strcat([ImageSaveFolder '\' imFullName '\'],'GroundTruth.jpg'));

     sobel_edge =edge(rgb2gray(imread(ImageFiles(i).name)),'sobel',0.08);
     canny_edge =edge(rgb2gray(imread(ImageFiles(i).name)),'canny',0.1);
      imwrite(sobel_edge,strcat([ImageSaveFolder '\' imFullName '\'],'Sobel.jpg'));
      imwrite(canny_edge,strcat([ImageSaveFolder '\' imFullName '\'],'Canny.jpg'));
     se=im2double(sobel_edge);
     ce=im2double(canny_edge);
     [val_sobel, dMap] = BDM(imgGT,se,'x', 2, 'euc');
     [val_canny, dMap] = BDM(imgGT,ce,'x', 2, 'euc');
    
    [parameters_vectors(:,i), best_BDM(i)] = myPSO(imgGrey, imgGT, coef, iteration, parameters);
    bestParameters = parameters_vectors(:,i);
    [bestPosition, bestCAEdgeImage] = fit_ness(imgGrey,imgGT, bestParameters); 
    imwrite(bestCAEdgeImage, strcat([ImageSaveFolder '\' imFullName '\'],'bestCAEdgeImage.jpg'));
   
    figure(bestParameters(3,1));
    subplot(2,3,1);imshow(imgGrey, []);
    title(['First Image'])
    subplot(2,3,2);imshow(imgGT);
    title(['Ground Truth'])
    subplot(2,3,3);imshow(se);
    title(['Sobel Detection : ', num2str(val_sobel)])
    subplot(2,3,4);imshow(ce);
    title(['Canny Detection : ', num2str(val_canny)])
    subplot(2,3,5);imshow(bestCAEdgeImage);
    title(['Proposed Method: ', num2str(bestPosition)])
    subplot(2,3,6);imshow(getMaskCA(parameters_vectors(3,i)));
    title(['Utilized CA'])
    saveas( figure(bestParameters(3,1)),strcat([ImageSaveFolderName '\' imFullName '\'],num2str(parameters_vectors(3,i)),'.jpg'),'jpg');
    save(strcat([ImageSaveFolderName '\' imFullName '\'],num2str(parameters_vectors(3,i))));
 end
    
 