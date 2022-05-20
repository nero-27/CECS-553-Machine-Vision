clc
clear all

%% read the image, apply gaussian and make it binary
img = imread("balloons.jpg");
figure, imshow(img);
title(['balloons image']);

% updated code
blurGaussImg = imgaussfilt(img, 3); % Hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
% imshow(blurGaussImg)
gaussImg = blurGaussImg(:, :, 3);
% figure, imshow(gaussImg)
gaussImg = im2bw(gaussImg, 0.35);
% figure, imshow(gaussImg)
gaussImg = imcomplement(gaussImg);
% figure, imshow(gaussImg)

filled = imfill(gaussImg, 'holes');
figure, imshow(filled)
title(['Binary image of balloons']);


%% count number of  objects

nrOfpixels = 55;                    % area of smallest balloon    
objs = bwareaopen(filled, nrOfpixels); % remove all objects smaller than given no of pixels

labels = bwlabeln(objs); 
% imshow(labels)
no_balloons = max(labels(:));
disp(no_balloons);

% get area of all balloons
areaOfBalloons = regionprops(labels, 'area');
disp(areaOfBalloons);
areaOfBalloons = [areaOfBalloons.Area];
disp(areaOfBalloons)


%% Sobel filter
  
% Convert to grayscale
input_image = rgb2gray(img);
  
% Convert image to double
input_image = double(input_image);
  
filtered_image = zeros(size(input_image));
  
% Sobel Operator Mask
Mx = [-1 0 1; -2 0 2; -1 0 1];
My = [-1 -2 -1; 0 0 0; 1 2 1];

for i = 1:size(input_image, 1) - 2
    for j = 1:size(input_image, 2) - 2
  
        Gx = sum(sum(Mx.*input_image(i:i+2, j:j+2)));
        Gy = sum(sum(My.*input_image(i:i+2, j:j+2)));
                 
        filtered_image(i+1, j+1) = sqrt(Gx.^2 + Gy.^2);
         
    end
end
  
filtered_image = uint8(filtered_image);

% Displaying Output Image
output_image = im2bw(filtered_image);
figure, imshow(output_image); title('Edge Detected Image');% Read Input Image

title(['Sobel filter: balloons in the image = ' num2str(no_balloons)])
saveas(gcf, 'no_of_balloons.jpg')


%% choose one balloon and change its pixels to white

% chose one area of balloon to extract
extracted = bwareafilt(filled,  [3237, 3237]);
figure, imshow(extracted)
title(['Extracted one balloon']);
saveas(gcf, 'one extracted balloon.jpg')

%% move balloon by 20 pixels

movedImg = zeros(size(extracted));
[a b ] = size(movedImg);
for i = 1:a
    for j=1:b
        if extracted(i,j) == 1;
%             movedImg(i,j) = 0;
            movedImg(i+20, j+20) = 1;   % move balloon to upper right 45 degrees
        end
    end
end

figure, imshow(extracted)
figure, imshow(movedImg)
% figure, imshow(movedImg)
title(['Image moved to down right by 20 pixels']);
saveas(gcf, 'moved image.jpg');

%% Choose a random air balloon in your binary image, change the pixels inside to white. Explain how you did that.
%{
 First i converted the image to binary. Then I used bwareafilt to extract
 one balloon with area 3257. Then I used the imfill() function to fill up
 the holes in the balloon to white.
%}

%% Move the balloon 20 pixels in any direction of 45-degree angle. Explain how you did that
%{
 Now that i have extracted a single balloon, I defined a matrix named
 movedImg of size of extracted image and filled it with zeros. I iterated
 through the row and col of image. Whenever I encountered 1 in the
 extracted image, I made the (row, col) value of movedImg 0 and (row+20,
 col-20) value of movedImg 1. 
%}






