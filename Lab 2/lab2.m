% read image
img = imread('colorful rocks 2.jpg')
% figure, imshow(img)

% convert img to grayscale
gray_img = rgb2gray(img)
% figure, imshow(gray_img)
gray_img = im2double(gray_img)

% convert to black and white
bw_gray_img = im2bw(gray_img, 0.72)
figure, imshow(bw_gray_img)

% save gray_img as png file
saveas(gcf, 'bw_gray_img.png')

% count number of gray rocks and print result
bwcomp = imcomplement(bw);
nrOfpixels = 1290       % area of smallest rock is 1290
objs = bwareaopen(bwcomp, nrOfpixels);
imshow(objs);
labels = bwlabeln_function(objs);
labels = bwlabeln(objs); 
numGrayrock = max(labels);
disp(numGrayrock);

help regionprops

% area of gray rocks
big_gray_rocks_area = regionprops(labels, 'area');
disp(big_gray_rocks_area)
big_gray_rocks_area = [big_gray_rocks_area.Area];
disp(big_gray_rocks_area)

save('big_gray_rocks_area.mat', "big_gray_rocks_area")

%{
%% Explain how you found area of gray rocks?
A. I used regionprops function on labels to get the area of all objects in
the image i.e. the gray rocks. 
%}  


% get the centroid of gray rocks
centroid_of_gray_rocks = regionprops(labels, 'centroid')
centroid_of_gray_rocks = cat(1, centroid_of_gray_rocks.Centroid)

imshow(bw_gray_img)
hold on
plot(centroid_of_gray_rocks(:,1), centroid_of_gray_rocks(:,2), 'r*')
hold off

%{
%% Explain how you found centroid of gray rocks?
A. I used regionprops function on labels to get the co-ordinates of centroid of all objects in
the image i.e. the gray rocks. Then I concatenated all 4 centroids into a
single array of 4 x 1. I then displayed the bw image using imshow and used
hold on and hold off to plot centroids on the image.
%} 

