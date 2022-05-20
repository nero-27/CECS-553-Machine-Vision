%% read images
clc
close
clear all

nr_im = 25;
img = imread(['z stack/1.tif']);


setdiff([1 2 3], [3 4 5])

finImg = zeros(size(img),'uint8');

%% convert all to binary and then add them together

finImg2 = zeros(512,512);
nrOfpixels = 5;                       
vol = zeros(size(1, 24));
volImg = zeros(512, 512);
class(volImg)

for i=1:nr_im
    im = imread(['z stack/',num2str(i),'.tif']);

    % convert to binary
    blurGaussImg = imgaussfilt(im, 1);
    gaussImg = im2bw(blurGaussImg, 0.1);
    filled = imfill(gaussImg, 'holes');
    finImg2 = finImg2 + filled;
    
end
% figure, imshow(finImg2);


%% count number of cells

nrOfpixels = 5;                       
objs = bwareaopen(finImg2, nrOfpixels); 
labels = bwlabeln(objs); 
% imshow(labels)
no_balloons = max(labels(:));
% disp(no_balloons);
X = ['number of cells = ', num2str(no_balloons)];
disp(X)

% get area of all cells
areaOfBalloons = regionprops(labels, 'area');
disp(areaOfBalloons);
areaOfBalloons = [areaOfBalloons.Area];
sort(areaOfBalloons)

centroid_of_cells = regionprops(labels, 'centroid');
centroid_of_cells = cat(1, centroid_of_cells.Centroid);
figure, imshow(finImg2)
hold on
plot(centroid_of_cells(:,1), centroid_of_cells(:,2), 'r*');
hold off
saveas(gcf, 'centroid_of_cells.jpg');

%% Q/A

%{
    . Explain how you would calculate the number of cells, volumes, and centers? (Note: If you 
have multiple answers in mind, break them apart and explain each one separately.) Explain 
each solution/algorithm in detail.

=> I did the following:
    > I read each image from the z stack
    > converted it to binary
    > added them together, say final_img
    > found the area of cells in final_img which is same as the volume of
    the cell
    > used the regionsprops function with centroid to find centroid of the
    cells in final_img
    > used bwareaopen to get rid of all white pixels less than the area of minimum cell (assuming its noise) and bwlabeln function to find the number of cells

%}

