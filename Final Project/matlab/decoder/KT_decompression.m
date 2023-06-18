clear
close all
clc

L=256;
test_original_image = imread('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_pic\Goldhill.bmp');
fid_3 = fopen('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_dat\huffman_code_ans.dat','r');
read_data = fscanf(fid_3 ,'%lu');
fclose(fid_3);

[r, c] = size(test_original_image);
if r ~= 256
    test_image = imresize(test_original_image ,[256 256]);
else
    test_image = test_original_image;
end

read_image = zeros(L ,L*2);
i_1 = 1;
for i = 1 : L
    for j = 1 : L*2
        read_image(i,j) = read_data(i_1);
        i_1 = i_1 + 1;
    end
end

[inv_image] = inv_huffman_coding(read_image ,L);

inv_image_merge = zeros(L ,L);
inv_image_merge_j = zeros(L ,L);
for m = 1 : L
    for n = 1 : L
        inv_image_merge(m,n) = (inv_image(m,2*n-1) * 16) + inv_image(m,2*n);
        if inv_image_merge(m,n) >= 2^7
            inv_image_merge_j(m,n) = inv_image_merge(m,n) - 2^8;
        else
            inv_image_merge_j(m,n) = inv_image_merge(m,n);
        end
    end
end

I_diff = inv_image_merge_j;
I_qua = zeros(L ,L);
I_qua(1:L ,1) = I_diff(1:L ,1);
I_qua(1:L ,(L/2+1)) = I_diff(1:L ,(L/2+1));
for k = 1 : L/2 - 1
    I_qua(1:L ,k+1) = I_qua(1:L ,k) + I_diff(1:L ,k+1);
    I_qua(1:L ,k+(L/2+1)) = I_qua(1:L ,(L/2+k)) + I_diff(1:L ,k+(L/2+1));
end

I_qua = I_qua .* 4;

%IDWT
[I_out_l ,I_out_h] = IDWT_column_processing(L ,I_qua(1 : (L/2) ,1 : (L/2)) ,I_qua(((L/2)+1):L ,1 : (L/2)) ,I_qua(1 : (L/2) ,((L/2)+1):L) ,I_qua(((L/2)+1):L ,((L/2)+1):L));
[inv_pic] = IDWT_row_processing(L ,I_out_l ,I_out_h);

%PSNR
MSE = 0;
for i = 1 : L
    for j = 1 : L
	    MSE = MSE + ((double(test_image(i ,j)) - double(inv_pic(i ,j))) ^ 2);
    end
end
MSE = MSE / (L ^ 2);
PSNR = 10 * (log10((255 ^ 2) / MSE));
disp(['PSNR = ',num2str(PSNR) ,' dB']);




% Display image after processing
figure(1)
imshow(mat2gray(double(test_image)));

figure(2)
imshow(mat2gray(double(inv_pic)));
