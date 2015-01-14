function [ TextureFeature ] = TextureFeature(im)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%im = imread('126007.jpg');
if(size(im,3) > 1)
   im = rgb2gray(im); 
end

window = 3;
threshold = 5;
im2 = impyramid(im,'reduce');
im3 = impyramid(im2,'reduce');

[im1Up, im1Down] = imageCensus(im,window,threshold);
[im2Up, im2Down] = imageCensus(im2,window,threshold);
[im3Up, im3Down] = imageCensus(im3,window,threshold);
histogrambins = 15;
final = cell(42,1);

final{1} = hist(reshape(im3Up,size(im3Up,1)*size(im3Up,2),1),histogrambins);
final{2} = hist(reshape(im3Down,size(im3Down,1)*size(im3Down,2),1),histogrambins);
[r, c] = size(im2Up);
count = 3;
for i = 1:2
    for j = 1:2
            rmin = round(r*(i-1)/2)+1;
            rmax = round(r*(i)/2);
            cmin = round(c*(j-1)/2)+1;
            cmax = round(c*(j)/2);
           final{count} = hist(reshape(im2Up(rmin:rmax,cmin:cmax),size(im2Up(rmin:rmax,cmin:cmax),1)*size(im2Up(rmin:rmax,cmin:cmax),2),1),histogrambins);
           count= count+1;
            final{count} = hist(reshape(im2Down(rmin:rmax,cmin:cmax),size(im2Down(rmin:rmax,cmin:cmax),1)*size(im2Down(rmin:rmax,cmin:cmax),2),1),histogrambins);
       
        
        
    end
end


for i = 1:4
    for j = 1:4
            rmin = round(r*(i-1)/4)+1;
            rmax = round(r*(i)/4);
            cmin = round(c*(j-1)/4)+1;
            cmax = round(c*(j)/4);
           final{count} = hist(reshape(im1Up(rmin:rmax,cmin:cmax),size(im1Up(rmin:rmax,cmin:cmax),1)*size(im1Up(rmin:rmax,cmin:cmax),2),1),histogrambins);
           count= count+1;
            final{count} = hist(reshape(im1Down(rmin:rmax,cmin:cmax),size(im1Down(rmin:rmax,cmin:cmax),1)*size(im1Down(rmin:rmax,cmin:cmax),2),1),histogrambins);
       
        
        
    end
end

TextureFeature=cell2mat(final')';
end

