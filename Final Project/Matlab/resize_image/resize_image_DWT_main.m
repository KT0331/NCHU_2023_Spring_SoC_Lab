clear all
close all
clc

%Read image
test_image = imread('HW3_test_image.bmp');
test_resize_image = fi(imresize(test_image ,[128 128]) ,0 ,8 ,0);
% test_resize_image = imresize(test_image ,[128 128]);

% %output image
% fid = fopen('test_resize_image.dat','wt');
% for i = 1 : 128
%     for j = 1 : 128
%         Z = dec2bin(test_resize_image(i,j) ,8);
%         fprintf(fid ,'%s' ,Z);
%         % fprintf(fid ,'//Pixel [%d]' ,i - 1);
%         % fprintf(fid ,'[%d]' ,j - 1);
%         fprintf(fid ,'\n');
%     end
% end
% fclose(fid);

%Define output result matrix
DWT_out_0 = zeros(128,128);
DWT_out_1 = zeros(128,128);

%Define image process length
L = 128;

%Define fixed point precision
layer1_fixed = numerictype(true, 10, 0); % max :  494 min : -114 width(min.) = f +  9 + 1 (f == fraction number)

%DWT
[out_l ,out_h] = DWT_row_processing(L ,test_resize_image ,layer1_fixed);
[out_ll ,out_hl ,out_lh ,out_hh] = DWT_column_processing(L ,out_l ,out_h ,layer1_fixed);
DWT_out_0(1:128 ,1 : 64) = out_l;
DWT_out_0(1:128 ,65 : 128) = out_h;
DWT_out_1(1 : 64 ,1 : 64)   = out_ll;
DWT_out_1(1 : 64 ,65 : 128)   = out_hl;
DWT_out_1(65 : 128 ,1 : 64)   = out_lh;
DWT_out_1(65 : 128 ,65 : 128) = out_hh;

%IDWT
[I_out_l ,I_out_h] = IDWT_column_processing(L ,out_ll ,out_lh ,out_hl ,out_hh);
[inv_pic] = IDWT_row_processing(L ,I_out_l ,I_out_h);

%PSNR
MSE = 0;
for i = 1 : 128
    for j = 1 : 128
	    MSE = MSE + ((double(test_resize_image(i ,j)) - double(inv_pic(i ,j))) ^ 2);
    end
end
MSE = MSE / (512 ^ 2);
PSNR = 10 * (log10((255 ^ 2) / MSE));
disp(['PSNR = ',num2str(PSNR) ,' dB']);

% %output DWT image
% fid_0 = fopen('test_resize_image_row_ans.dat','wt');
% for i = 1 : 128
%     for j = 1 : 128
%         %if DWT_out_0(i,j) >= 0
%             Z1 = dec2bin(DWT_out_0(i,j) ,10);
%             fprintf(fid_0 ,'%s' ,Z1);
%         %else
%         %    fprintf(fid_0 ,'%s' ,(2^(10) + DWT_out_0(i,j)));
%         %end
%         % fprintf(fid_0 ,'//Pixel [%d]' ,i - 1);
%         % fprintf(fid_0 ,'[%d]' ,j - 1);
%         fprintf(fid_0 ,'\n');
%     end
% end
% fclose(fid_0);

% fid_1 = fopen('test_resize_image_column_ans.dat','wt');
% for i = 1 : 128
%     for j = 1 : 128
%         %if DWT_out_1(i,j) >= 0
%             Z2 = dec2bin(DWT_out_1(i,j) ,10);
%             fprintf(fid_1 ,'%s' ,Z2);
%         %else
%         %    fprintf(fid_1 ,'%03x' ,(2^(10) + DWT_out_1(i,j)));
%         %end
%         % fprintf(fid_1 ,'//Pixel [%d]' ,i - 1);
%         % fprintf(fid_1 ,'[%d]' ,j - 1);
%         fprintf(fid_1 ,'\n');
%     end
% end
% fclose(fid_1);

% a = max(max(DWT_out_0));
% b = min(min(DWT_out_0));
% c = max(max(DWT_out_1));
% d = min(min(DWT_out_1));