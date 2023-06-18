clear all
close all
clc

L=256;
test_image = imread('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_pic\Cameraman.bmp');
fid_3 = fopen('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_dat\huffman_code_ans.dat','r');
read_data = fscanf(fid_3 ,'%lu');
fclose(fid_3);

i_1 = 1;
for i = 1 : L/2
    for j = 1 : L*4
        read_image(i,j) = read_data(i_1);
        i_1 = i_1 + 1;
    end
end

[inv_image] = inv_huffman_coding(read_image);

for m = 1 : L/2
    for n = 1 : L*2
        inv_image_merge(m,n) = (inv_image(m,2*n-1) * 16) + inv_image(m,2*n);
        if inv_image_merge(m,n) >= 2^7
            inv_image_merge(m,n) = inv_image_merge(m,n) - 2^8;
        else
            inv_image_merge(m,n) = inv_image_merge(m,n);
        end
    end
end

diff_0 = inv_image_merge(1:L/2,1:4)';
diff_1 = inv_image_merge(1:L/2,5:3+(L/2));
diff_2 = inv_image_merge(1:L/2,4+(L/2):2+L);
diff_3 = inv_image_merge(1:L/2,3+L:1+((3*L)/2));
diff_4 = inv_image_merge(1:L/2,2+((3*L)/2):2*L);

I_qua = zeros(L, L);

for k0 = 1:(L/2)
    if k0 == 1
        I_qua(1:(L/2) ,k0) = diff_0(1 ,1:(L/2))';
    else
        I_qua(1:(L/2) ,k0) = I_qua(1:(L/2) ,k0-1) + diff_1(1:(L/2) ,k0-1);
    end
end
for k1 = 1:(L/2)
    if k1 == 1
        I_qua(1:(L/2) ,k1+(L/2)) = diff_0(2 ,1:(L/2))';
    else
        I_qua(1:(L/2) ,k1+(L/2)) = I_qua(1:(L/2) ,k1+(L/2)-1) + diff_2(1:(L/2) ,k1-1);
    end
end
for k2 = 1:(L/2)
    if k2 == 1
        I_qua(((L/2)+1):L ,k2) = diff_0(3 ,1:(L/2))';
    else
        I_qua(((L/2)+1):L ,k2) = I_qua(((L/2)+1):L ,k2-1) + diff_3(1:(L/2) ,k2-1);
    end
end
for k3 = 1:(L/2)
    if k3 == 1
        I_qua(((L/2)+1):L ,k3+(L/2)) = diff_0(4 ,1:(L/2))';
    else
        I_qua(((L/2)+1):L ,k3+(L/2)) = I_qua(((L/2)+1):L ,k3+(L/2)-1) + diff_4(1:(L/2) ,k3-1);
    end
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
imshow(mat2gray(double(inv_pic)));
