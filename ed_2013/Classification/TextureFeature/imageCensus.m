function [ resultUp, resultDown ] = imageCensus( im,window,threshold )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
resultUp = zeros(size(im));
resultDown = zeros(size(im));
im = padarray(im,[1 1],'replicate'); % must be grey
 for row = 2: size(im,1)-1
     for col = 2:size(im,2)-1
         A = im(row-1:row+1,col-1:col+1);
          [ outputUp, outputDown ] = CensusTransform( A, window,threshold );
          resultUp(row-1,col-1) = outputUp;
          resultDown(row-1,col-1) = outputDown;
     end
 end

end

