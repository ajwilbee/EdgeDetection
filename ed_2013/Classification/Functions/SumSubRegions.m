function [ gist ] = SumSubRegions(channel, NumSquaresPerSide )
%SUMSUBREGIONS Summary of this function goes here
%   returns the averaged value in the subregions of an image
%   input: 
%       NumSquaresPerSide =number of subregions on a side
%        channel = the color channel to be processed
%   output: the gist descriptor for that region
gist = zeros(NumSquaresPerSide^2*length(channel),1);
count = 1;
for level = 1:length(channel)
    [r, c] = size(channel{level});
    
    for i=1:4
        for j=1:4
            rmin = round(r*(i-1)/4)+1;
            rmax = round(r*(i)/4);
            cmin = round(c*(j-1)/4)+1;
            cmax = round(c*(j)/4);
           gist(count) = sum(sum(channel{level}(rmin:rmax,cmin:cmax)))/(16*(rmax-rmin)*(cmax-cmin));
           count = count +1;
        end
    end
end

end

