%% New Edge Detection Method with rule matrix multiplication 
% corresponds to edge definition with wxw mask filter
%clc
close all;
clear all;
%% Kural ve iterasyon sayisini giriniz 
    wsize=3;
     I =im2double(rgb2gray(imread('2018.jpg')));
     image1 =im2double(rgb2gray(imread('2018.jpg')));    
     imFullName ='SnowShoes';
     sobel_edge =edge(rgb2gray(imread('2018.jpg')),'sobel',0.08);
     figure(1)
     %imshow(sobel_edge)
     canny_edge =edge(rgb2gray(imread('2018.jpg')),'canny',0.1);
     %imshow(I)
%% Parameter Initialization
n=size(image1,1);
m=size(image1,2);
image=zeros(n,m);
t1=100 ; % >64
t2=20 ; % <64
ru=1;%270 211
low =0;upper=511;equal=[];
%imshow(M1,[])
%%  CA_Fuzzy ED Procedure
tic
while ((low<ru)&(ru<upper))
for i=1:n
    for j=1:m
        if (j+2<=m) && (i+2<=n)
                mask=I(i:i+2,j:j+2);
                rule_nbd=maskCA(ru,mask);
                %% Fuzzy CA
                mean_nhd= mean(rule_nbd);
                std_nhd = std(rule_nbd);
                if (std_nhd ==0)
                
                  image(i+1,j+1)=1;
                else
                mf_val     = gaussmf(rule_nbd, [std_nhd mean_nhd]);    
                
                image(i+1,j+1)=mf_val(:,1);
                end
         end
     end
end
%% 
image2=image;
[val_sobel, dMap] = BDM(image1,sobel_edge,'x', 2, 'euc');
[val_canny, dMap] = BDM(image1,canny_edge,'x', 2, 'euc');
[val_CA, dMap] = BDM(image1,image2,'x', 2, 'euc');
toc

%image_new =rem(image+1,2);
figure(ru);
subplot(2,3,1);imshow(I, []);
title(['First Image'])
subplot(2,3,2);imshow(image1);
title(['Ground Truth'])
subplot(2,3,3);imshow(sobel_edge);
title(['Sobel  : ', num2str(val_sobel)])
subplot(2,3,4);imshow(canny_edge);
title(['Canny  : ', num2str(val_canny)])
subplot(2,3,5);imshow(image2);
title(['CAFuzzy  : ', num2str(val_CA)])
%%
if upper-ru>1
    close all;
end
saveas(figure(ru),strcat('ManyRules/',imFullName,'_it_',num2str(ru),'.jpg'),'jpg');
saveas(figure(ru),strcat('ManyRules/','im',num2str(ru),'.fig'),'fig');
ru=ru+1;
end
%pause(0.5)
%% Results

ValED = [val_sobel val_canny val_CA]
