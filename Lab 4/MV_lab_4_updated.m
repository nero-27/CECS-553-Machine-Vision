%% clear all
clc
close
clear all

%% read images from tiny folder

nr_im = 150;
for i = 1:nr_im
    
    im = imread(['tiny/im',num2str(i),'.png']);  % ****************** Question ****************** Read each image located in tiny folder

    All(:,:,:,i) = im;                       % Save all of the imgs in All
end
sz = size(All)
All = reshape(All,sz(1)*sz(2)*sz(3),nr_im);  % Change All into a matrix (each col = one img)
sz = size(All)

% Test to see what has happened...
im = All(:,1);
im = reshape(im,32,32,3);
imshow(im)

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
fclose(fileID)                          % Close the file

%% K-Fold Cross Validation
% k_fold = 10;
% c1 = cvpartition(nr_im,'KFold',k_fold)       % Define a random partition for k folds
% test_data = test(c1,1);
% trains = training(c1,1);
% test_data_ids = find(test_data == 1);   % 15 testing images
% val_fold = 9
% c2 = cvpartition(sum(trains),"KFold", val_fold)

val_fold = 9;
c1 = cvpartition(nr_im, 'HoldOut', 0.1);
test_data = test(c1, 1);
c1.TrainSize;
c2 = cvpartition(c1.TrainSize,'KFold',val_fold);




%% 4. Leave one-fold aside for testing and the remaining 9 folds for training and validation. Explain how you did that.
%{
I first did cvpartition on 150 images using 10 kfolds. Then I used the
number of train images (135) and cvpartition them second time where I used  9 kfolds so get
120 training images and 15 validation images
%}

%% 

Kclosest = 15;

accuracy = zeros(1,15);
for nearest = 1:Kclosest
    for k=1:val_fold

        val_data = test(c2,k);
        train_data = training(c2,k);
        val_data_ids = find(val_data == 1);     % 15 validation images
        train_data_ids = find(train_data == 1);     % 120 training images
        
        acc = 0
        nr_val = sum(val_data);  %****************** Question ****************** Find the total number of test data 
        nr_train = sum(train_data); %****************** Question ****************** 
        
         
%         val_ids = val_data_ids(1:end);
        [a b ] = size(val_data_ids)
        

        for i=1:a
            testIm = All(:,val_data_ids(i));         % take all pixel values from ALL matrix from column testID
            dst = abs(All(:,train_data)-repmat(testIm,1,nr_train));   
            dst = sum(dst); % sum cols by default
            [~,mnIdx] = mink(dst,nearest);                         % Find the k smallest elements
    %         trainID = find(idxTrain == 1);
            testLab = labels(train_data);
            lab = testLab(mnIdx);
%             vote = labels(train_data(mnIdx));     
            vote = mode(lab);                          
%             vote == labels(val_data_ids(i));
            acc = acc + (vote == labels(val_data_ids(i)));  % Check to see if you predicted the label correctly
            
        end
        accuracy(nearest) = acc / size(val_data_ids,1)
    end
    
% final_acc = accuracy / val_fold
end

%% plotting accuracy for every value of k=1 to 15
clc
close all
k = [1:Kclosest];   
bar(accuracy)
saveas(gcf, 'accuracy.jpg');

% fin_k = 0
maximum = max(accuracy)
fin_k = abs(find(accuracy == maximum))
fink_k = fin_k(1);

%% accuracy is highest for k = 2

% for i=1:val_fold
%     fin_train_idx = training(c2,i);
%     fin_test_idx = test(c2,i);
% 
%     fin_testID = find(fin_test_idx == 1);
% 
no_of_train = sum(test_data);
% 
fin_acc = 0
%   
test_data_idx = find(test_data == 1);

[m n ] = size(test_data_idx)

for j=1:m
    testIm = All(:,test_data_idx(j));       

    dst = abs(All(:,test_data)-repmat(testIm,1,no_of_train));   
    dst = abs(sum(dst)); % sum cols by default
    [~,mnIdx] = mink(dst,fin_k);                         % Find the k smallest elements
    testLab = labels(test_data);
    lab = testLab(mnIdx);
%         lab = labels(fin_train_idx)
    vote = mode(lab);                          
    fin_acc = fin_acc + (vote == labels(test_data_idx(j)));
end
fin_acc = fin_acc / size(test_data_idx,1)



