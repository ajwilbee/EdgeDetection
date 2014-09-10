%% 10/10/2013 2013 Edge Detection çal??mas? tamamland?. Üç image için
% elde edilen sonuçlar ve parametreler a?a??dad?r. 

%% New Edge Detection Method with rule matrix multiplication 
% corresponds to edge definition with wxw mask filter
clc
close all;
clear all;
ImageFilesPath = 'C:\Users\ajw4388\Documents\Thesis\BSR\BSDS500\data\images\test';
GroundTruthFilesPath = 'C:\Users\ajw4388\Documents\Thesis\BSR\BSDS500\data\groundTruth\test';
ImageSaveFolderName = 'AllRules_AllImages'; % make this ahead of time
ImageSaveFolder = [pwd '\' ImageSaveFolderName];
addpath(ImageFilesPath,GroundTruthFilesPath);
ImageFiles = dir(fullfile(ImageFilesPath, '*.jpg'));
GroundTruthFiles = dir(fullfile(GroundTruthFilesPath, '*.mat'));

for imNum = 10:length(ImageFiles)
        imFullName =ImageFiles(imNum).name(1:end-4);
        im = imread(ImageFiles(imNum).name);
        IGrey =double(rgb2gray(im));
        load(GroundTruthFiles(imNum).name);
        IGT   =im2double(groundTruth{1}.Boundaries);

        sobel_edge =edge(rgb2gray(imread(ImageFiles(imNum).name)),'sobel',0.08);
        canny_edge =edge(rgb2gray(imread(ImageFiles(imNum).name)),'canny',0.1);

         %imshow(I)
    %% Parameter Initialization
    n=size(IGrey,1);
    m=size(IGrey,2);
    image=zeros(n,m);
    %% 
    %% FOR image %5 72 307 0.5940     16.6555   15.2550   16.1354
    %% FOR image %4 98 309 0.6854    26.7730   26.6502   26.1285
    %% FOR image %7 103 434 0.5097    4.4261    4.0132    3.9561
    %% FOR image %7 98 433 0.4996

    %% For image %8 59 139 0.414  5.0845   6,2199 6,3203
    %% For image %9 68 154 0.6078  17,8975   6,2199 6,3203
    %% For image %10 136 60 0.3889  16,5750  6,2199 6,3203
    %% For image %12 83 0.6642  194  10.6962  7,2074 10,6962



    t=83
    ru=1 ;%270 211
    low =ru-1;upper=511;equal=[];
    newtime = 0;
    oldtime = 0;
    %imshow(M1,[])
    %%  CA_Fuzzy ED Procedure
    tic

    %   49.1676   49.0601   49.9278
    mkdir(ImageSaveFolderName,imFullName);
    mkdir([ImageSaveFolderName '\' imFullName], 'JPG');
    mkdir([ImageSaveFolderName '\' imFullName], 'MAT');
    
    se=im2double(sobel_edge);
    ce=im2double(canny_edge);
    [val_sobel, dMap] = BDM(IGT,se,'x', 2, 'euc');
    [val_canny, dMap] = BDM(IGT,ce,'x', 2, 'euc');
    while ((low<ru)&(ru<upper))
        MaskCA = getMaskCA(ru); %incorperate the masking and addition into the function so it will run faster
    for i=1:n
        for j=1:m
            if (j+2<=m) && (i+2<=n)
                    mask=IGrey(i:i+2,j:j+2);
                    rule_nbd=sumsum((MaskCA.*mask));
                    %% Fuzzy CA sum the cells of the rule and then divide by weighted sum to determine next state
                    mf = sum(abs(mask(2,2)-rule_nbd))/(sum( abs(mask(2,2)-rule_nbd))+t); %why this step?
                    if mf >0.3
                        image(i+1,j+1)=1;
                    else
                        image(i+1,j+1)=0;
                    end
             end
         end
    end
    %% 
    ImgCA=image;

    [val_CA, dMap] = BDM(IGT,ImgCA,'x', 2, 'euc');
    oldtime = newtime;
    newtime=toc;
    disp(newtime-oldtime);


    %image_new =rem(image+1,2);
    figure(ru);
    subplot(2,3,1);imshow(IGrey, []);
    title(['First Image'])
    subplot(2,3,2);imshow(IGT);
    title(['Ground Truth'])
    subplot(2,3,3);imshow(se);
    title(['Sobel Detection : ', num2str(val_sobel)])
    subplot(2,3,4);imshow(ce);
    title(['Canny Detection : ', num2str(val_canny)])
    subplot(2,3,5);imshow(ImgCA);
    title(['Proposed Method: ', num2str(val_CA)])
    %%
    % if upper-ru>1
    %     close all;
    % end
    % saveas(figure(ru),strcat(imFullName,'_RN_',num2str(ru),'.jpg'),'jpg');
    % saveas(figure(ru),strcat(imFullName,'_RN_',num2str(ru),'.eps'),'eps');
    % saveas(figure(ru),strcat(imFullName,'_RN_',num2str(ru),'.tiff'),'tiff');
    %saveas(figure(ru),strcat('im',num2str(ru),'.fig'),'fig');
    
    saveas(figure(ru),strcat([ImageSaveFolderName '\' imFullName], '\JPG', '\Rule',num2str(ru),'.jpg'),'jpg');
    saveas(figure(ru),strcat([ImageSaveFolderName '\' imFullName], '\MAT', '\Rule',num2str(ru),'.fig'),'fig');
    ru=ru+1;
    close all;
    end
    
end
%pause(0.5)
%% Results

%ValED = [val_sobel val_canny val_CA]
