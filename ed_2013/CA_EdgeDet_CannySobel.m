%% 10/10/2013 2013 Edge Detection çal??mas? tamamland?.
% Canny ve Sobel sonuçlar?n? h?zl?ca elde etmek için olu?turulmu? dosya

%% New Edge Detection Method with rule matrix multiplication 
% corresponds to edge definition with wxw mask filter
%%
clc
close all;
clear all;
%% Kural ve iterasyon sayisini giriniz 
    wsize=3;
     I =double(imread('Im11_grey.jpg'));
     image1 =(imread('Im11.jpg'));    
     imFullName ='Pep_CA';
     sobel_edge =edge(imread('Im11_grey.jpg'),'sobel',0.121);
     canny_edge =edge(imread('Im11_grey.jpg'),'canny',[0.01 0.45]);
     %imshow(I
%% Parameter Initialization
% Im 12 sobel 0.09 canny 0.018 0.2  
% Im 11 sobel 0.121 canny 0.01 0.45  
% Im 10 sobel 0.076 canny 0.07 0.4
% Im 9 sobel 0.101 canny 0.09 0.1
% Im 8 sobel 0.102 canny 0.01 0.07
% Im 7 sobel 0.089 canny 0.048 0.12
% Im 5 sobel 0.091 canny 0.19 0.2
% Im 4 sobel 0.12 canny 0.17 0.2


n=size(image1,1);
m=size(image1,2);
image=zeros(n,m);
t=106
ru=321;%270 211
low =ru-1;upper=ru+1;equal=[];
%imshow(M1,[])
%%  CA_Fuzzy ED Procedure
tic

%   49.1676   49.0601   49.9278
se=im2double(sobel_edge);
ce=im2double(canny_edge);
[val_sobel, dMap] = BDM(image1,se,'x', 2, 'euc');
[val_canny, dMap] = BDM(image1,ce,'x', 2, 'euc');
toc

%image_new =rem(image+1,2);
figure(ru);
subplot(1,4,1);imshow(I, []);
title(['First Image'])
subplot(1,4,2);imshow(image1);
title(['Ground Truth'])
subplot(1,4,3);imshow(se);
title(['Sobel Detection : ', num2str(val_sobel)])
subplot(1,4,4);imshow(ce);
title(['Canny Detection : ', num2str(val_canny)])

%%
%% Results

ValED = [val_sobel val_canny]
