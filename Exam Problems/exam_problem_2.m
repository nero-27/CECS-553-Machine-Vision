clc
close
clear all

%% load images and vectorize it

nr_im = 150;
for i = 1:nr_im
    
    im = imread(['tiny/im',num2str(i),'.png']);  % ****************** Question ****************** Read each image located in tiny folder

    All(:,:,:,i) = im;                       % Save all of the imgs in All
end

sz = size(All)
All = reshape(All,sz(1)*sz(2)*sz(3),nr_im);  % Change All into a matrix (each col = one img)
size(All);

All = transpose(All);
size(All)

%% Read the labels
fileID = fopen('tiny/labels.txt','r');  % Open the txt file for reading
chr = fscanf(fileID,'%c');              % Read data, '%c' = Read any single character
range = sscanf(chr,'%d');               % Convert chr to numbers, '%d' = integers
NrLabels = length(range)/2;
range(2)


for i = 1:NrLabels
    labels(range((2*i)-1): abs(range(2*i))) = i
%     labels % ****************** Question ****************** Define a row vector of size nr_im and save the labels for each img/row in All
end
fclose(fileID)   


%% perform PCA on All

mu = mean(All, 2);
a = repmat(mu, 1, size(All,2));
All = cast(All, 'double');
% size(a)
D = All - a;
DT = transpose(D);
cov = (D*DT) / nr_im;

[P, eigValues] = eig(cov);
P = fliplr(P);
variance = flip(sum(eigValues));
P = P(:, 1:73)
new_all = transpose(P)*D;


%% partition into train and test

nr_new_all = size(new_all,1);
K = 10;
c1 = cvpartition(nr_new_all, "KFold", K);
test_bi = test(c1,1);
train_bi = training(c1,1);

test_idx = find(test_bi == 1);
train_idx = find(train_bi == 1);

nr_train = sum(train_bi);
nr_test = sum(test_bi);

%% perform K-means

Kclosest = 3; 
testId = test_idx(1:end);
[a b ] = size(test_idx);
acc = 0;
fin_acc = 0;
Kclosest = 3;

for k=1:K
    for i=1:a
        testIm = All(:,testId(i));         % take all pixel values from ALL matrix from column testID
        dst = abs(All(:,train_bi)-repmat(testIm,1,nr_train));   % Calculate the distance between all training imgs and the test img

        dst = sum(dst); % sum cols by default
        [~,mnIdx] = mink(dst,3);                         % Find the k smallest elements
        trainID = find(train_bi == 1);

        testLab = labels(train_bi);
        lab = testLab(mnIdx);
        vote = mode(lab);
        acc = acc + (vote == labels(testId(i)));
    end
%     accuracy(nearest) = acc / size(testId,1)
end
final_acc = (acc / size(testId, 1) ) / K

%% Q/A
%{ 
A. How would you create your model to classify the objects? (Note: If you have multiple 
answers in mind, break them apart and explain each one separately.) Explain each 
solution/algorithm in detail.

=> I did the following:
    > I first took transpose of All matrix to get number of images in rows
    and features in columns
    > i applied PCA on All matrix using following steps
        > found mean of every sample and subtracted from every feature of
        that sample, called it D
        > calculated D*D.T (D.T is transpose of D)
        > found covariance matrix cov = D*D.T / no. of images
        > used eig() function to get eigenvectors and eigenvalues
        > flipped the eigenvectors and tool first 73 values
        > multiplied transpose of it by D and projected the data calling it
        new_all
    > partitioned the new_all into test and train using 10 folds
    > K_closest = 3 and applied K-means
    > got final accuracy as 0.8571

%}



