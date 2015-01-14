%% PSO for CA_Fuzzy Edge Detection

%% main.m, mpPSO.m, fit_ness.m, maskCA.m
%% 10/10/2013 2013 Edge Detection çal??mas? tamamland?.
close all
%clear all
clc
%%


%%
iteration =100;
%starting point for PSO: 1-> division offset 2-> fuzzy boundery 3-> CA rule
parameters = [60 0.3 23;79 1 124; 105 0 321; 23 0.3 452;78 0.01 35;92 0.6 326;73 0.43 168;86 0.87 245; 112 0.54 410;124 0.67 203;
              51 0.23 123;69 0.89 24; 101 0.34 121; 39 0.4 45;71 0.19 355;97 0.73 56;134 0.3 18;35 0.71 45;68 0.47 386;82 0.712 178;];
         
imFullName = '388006.jpg';
imGroundTruth = '388006.mat';
whichGroundTruth = 2;
im = imread(imFullName);
imgGrey =double(rgb2gray(im));
load(imGroundTruth);
imgGT = double(groundTruth{whichGroundTruth}.Boundaries);
          
size(parameters);
c1 =2.01;
c2 = 2.01;
[row,col] = size (imgGrey);
coef =[.73 c1 c2];
%dbstop in fit_ness

   

    
    [parameters_vectors(:,1), best_BDM(1)] = myPSO(imgGrey, imgGT, coef, iteration, parameters);
    bestParameters = parameters_vectors(:,1);
    [bestPosition, bestCAEdgeImage] = fit_ness(imgGrey,imgGT, bestParameters); 
   
    figure(bestParameters(3,1));
    subplot(2,3,1);imshow(imgGrey, []);
    title(['First Image'])
    subplot(2,3,2);imshow(imgGT);
    title(['Ground Truth'])
    subplot(2,3,5);imshow(bestCAEdgeImage);
    title(['Proposed Method: ', num2str(bestPosition)])
    subplot(2,3,6);imshow(getMaskCA(parameters_vectors(3,i)));
    title(['Utilized CA'])
 
    
 