function [ WV ] = matrixize( inputarray, r,c )
%UNTITLED6 Summary of this function goes here
%   takes in the number of rows (r) and columns(c) and a one dimentional array
%   that is the same length.
%   returns a matrix of that is the size of the rows and columns and
%   contains all of the elements in the input array.
%   the input elements are expected to be arranged by row, eg first row are
%   the first c elements, last row are the last c elements
    WV = zeros(r,c);
    for i = 1: r
        WV(i,:) = inputarray((i-1)*c+1:i*c);   
    end

end

