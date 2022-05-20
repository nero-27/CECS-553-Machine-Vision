%% EXTRA CREDIT - Implementing im2bw function from scratch 

function [gray_im] = im2bw_function(gray_im, threshold)
% function coverts im2double grayscale image to binary using the given threshold

[m, n] = size(gray_im)

for i=1:m
    for j=1:n
        if gray_im(i,j) >= threshold
            gray_im(i,j) = 1;    
        else
            gray_im(i,j) = 0;
        end
    end
end

return 

end

