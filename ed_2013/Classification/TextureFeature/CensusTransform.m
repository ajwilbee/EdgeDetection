function [ outputUp,outputDown ] = CensusTransform( A, window ,thresh)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    %window = 3; % window must be odd
    % A = [171 171 46; 171 64 46; 63 64 46]; this is the window that needs
    % to be processed for its texture
    val = zeros(1,window^2-1);
    val2 = zeros(1,window^2-1);
    center = floor(window /2) +1;
    count  = 1;

    for row = 1:window
        for col = 1:window
            if(row == center && col == center)
            else
                
                if(A(row,col) >= A(center,center)+thresh)
                    val(count) = 1;
                else
                    val(count) = 0;
                end
                if(A(row,col) <= A(center,center)-thresh)
                    val2(count) = 1;
                else
                    val2(count) = 0;
                end
                    count = count +1;
            end
        end
    end

    outputUp = bin2dec(num2str(val)); % the consensus value
    outputDown =  bin2dec(num2str(val2));

end

