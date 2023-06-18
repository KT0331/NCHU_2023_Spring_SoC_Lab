clear
close all
clc

%Read image
test_image = imread('HW3_test_image.bmp');
test_resize_image = fi(imresize(test_image ,[256 256]) ,0 ,8 ,0);

% Display image after processing
figure(1)
imshow(mat2gray(double(test_image)));

figure(2)
imshow(mat2gray(double(test_resize_image)));
