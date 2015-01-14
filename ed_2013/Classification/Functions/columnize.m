function [ WV ] = columnize(inputArray )
%UNTITLED4 Summary of this function goes here
%  input: 2-dimentional matrix
%  output: 1 dimentional matrix (single column) which contains all the values
%  of the input
    [r,c] = size(inputArray);
    WV = zeros(r*c,1);
    for i = 1: r
        WV((i-1)*c+1:i*c) = inputArray(i,1:end);   
    end

end

