clear
close all
clc

%Define image process length
L = 256;

%Read image
test_original_image = imread('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_pic\Babara.bmp');
[r, c] = size(test_original_image);
if r ~= 256
    test_image = imresize(test_original_image ,[256 256]);
else
    test_image = test_original_image;
end
% test_image = zeros(L,L);
% for ii = 1 : L
%     for jj = 1 : L
%         test_image(ii,jj) = 255;
%     end
% end

% fid = fopen('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_dat\test_pic_sdk.dat','wt');
% for i = 1 : L
%     for j = 1 : L
%         % Z = test_image(i,j);
%         % fwrite(fid ,Z ,'uint8');
%          Z = dec2hex(test_image(i,j) ,2);
%         fprintf(fid ,'%s' ,Z);
%     end
% end
% fclose(fid);

test_image = fi(test_image ,0 ,8 ,0);

test_image_0 = fi(test_image(1:L ,1:L) ,0 ,8 ,0);
% test_image_1 = fi(test_image(1:64 ,1:64) ,0 ,8 ,0);
% test_image_2 = fi(test_image(1:64 ,1:64) ,0 ,8 ,0);
% test_image_3 = fi(test_image(1:64 ,1:64) ,0 ,8 ,0);

%Define output result matrix
DWT_out_0 = zeros(L,L);
DWT_out_1 = zeros(L,L);

%Define fixed point precision
layer1_fixed = numerictype(true, 10, 0); % max :  504 min : -223 width(min.) = f +  9 + 1 (f == fraction number)
% qua_fixed = numerictype(true, 8, 0);

%DWT
[out_l ,out_h] = DWT_row_processing(L ,test_image_0(1:L ,1:L) ,layer1_fixed);
[out_ll ,out_hl ,out_lh ,out_hh] = DWT_column_processing(L ,out_l ,out_h ,layer1_fixed);
DWT_out_0(1:L ,1:(L/2)) = out_l;
DWT_out_0(1:L ,(L/2)+1:L) = out_h;
DWT_out_1(1:(L/2) ,1:(L/2))   = out_ll;
DWT_out_1(1:(L/2) ,(L/2)+1:L)   = out_hl;
DWT_out_1((L/2)+1:L ,1:(L/2))   = out_lh;
DWT_out_1((L/2)+1:L ,(L/2)+1:L) = out_hh;

% fid_1 = fopen('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_dat\DWT_column_out.dat','wt');
% for i = 1 : L
%     for j = 1 : L
%         Z = dec2bin(DWT_out_1(i,j) ,10);
%         fprintf(fid_1 ,'%s\n' ,Z);
%     end
% end
% fclose(fid_1);
% 
% fid_2 = fopen('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_dat\DWT_row_out.dat','wt');
% for i = 1 : L
%     for j = 1 : L
%         Z = dec2bin(DWT_out_0(i,j) ,10);
%         fprintf(fid_2 ,'%s\n' ,Z);
%     end
% end
% fclose(fid_2);

% qua = zeros(512, 512, 'like', fi([], qua_fixed));
% qua = zeros(L, L);
qua = fix(DWT_out_1 ./ 4);
diff_1 = qua(1:(L/2) ,2:(L/2)) - qua(1:(L/2) ,1:((L/2)-1));
diff_2 = qua(1:(L/2) ,((L/2)+2):L) - qua(1:(L/2) ,((L/2)+1):(L-1));
diff_3 = qua(((L/2)+1):L ,2:(L/2)) - qua(((L/2)+1):L ,1:((L/2)-1));
diff_4 = qua(((L/2)+1):L ,((L/2)+2):L) - qua(((L/2)+1):L ,((L/2)+1):(L-1));
diff = [qua(1:(L/2),1), diff_1, qua(1:(L/2),((L/2)+1)), diff_2; qua(((L/2)+1):L,1), diff_3, qua(((L/2)+1):L,((L/2)+1)), diff_4];

% qua1 = [(bitget(qua,8,'int8')*8+bitget(qua,7,'int8')*4+bitget(qua,6,'int8')*2+bitget(qua,5,'int8')) (bitget(qua,4,'int8')*8+bitget(qua,3,'int8')*4+bitget(qua,2,'int8')*2+bitget(qua,1,'int8'))];

diff_h = zeros(L, 2*L);
q = 1;
for m = 1 : L
    for n = 1 : L
        diff_h(m,q) = (bitget(diff(m,n),8,'int8')*8+bitget(diff(m,n),7,'int8')*4+bitget(diff(m,n),6,'int8')*2+bitget(diff(m,n),5,'int8'));
        diff_h(m,q+1) = (bitget(diff(m,n),4,'int8')*8+bitget(diff(m,n),3,'int8')*4+bitget(diff(m,n),2,'int8')*2+bitget(diff(m,n),1,'int8'));
        % qua_h(m,q) = [(bitget(qua(m,n),8,'int8')*8+bitget(qua(m,n),7,'int8')*4+bitget(qua(m,n),6,'int8')*2+bitget(qua(m,n),5,'int8'))];
        % qua_h(m,q+1) = [(bitget(qua(m,n),4,'int8')*8+bitget(qua(m,n),3,'int8')*4+bitget(qua(m,n),2,'int8')*2+bitget(qua(m,n),1,'int8'))];
        q = q+2;
    end
    q = 1;
end

% a = unique(qua1);
% figure(1);
% b = histogram(qua1 ,16);
% count_qua1 = b.Values;
% disp(count_qua1);
% c = unique(diff);
% figure(2);
% d = histogram(diff ,16);
% count_diff = d.Values;
% disp(count_diff);

[huffman_code] = huffman_coding(diff_h,L);

% output encoder data
% fid_3 = fopen('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_dat\huffman_code_ans.dat','wt');
% for i = 1 : L
%     for j = 1 : L*2
%         fprintf(fid_3 ,'%015d\n' ,huffman_code(i,j));
%     end
% end
% fclose(fid_3);

[outstr_sdk] = huffman_coding_transfer2binary(huffman_code,L);

fid_5 = fopen('C:\Users\ASUS\Desktop\University\大四\Grad_Lab in System on Chip Integrated Design\final project\matlab\test_dat\huffman_code_golden_sdk.dat','wt');
for i = 1 : L
    for j = 1 : 2*L
        Z = dec2hex(outstr_sdk(i,j) ,4);
        fprintf(fid_5 ,'%s' ,Z);
    end
end
fclose(fid_5);

% % Display image after processing
% figure(1)
% imshow(mat2gray(double(test_image)));
% 
% figure(2)
% imshow(mat2gray(double(inv_pic)));
% 
% a_0 = max(max(diff_0));
% a_1 = min(min(diff_0));
% a0 = max(max(diff_1));
% a1 = min(min(diff_1));
% b0 = max(max(diff_2));
% b1 = min(min(diff_2));
% c0 = max(max(diff_3));
% c1 = min(min(diff_3));
% d0 = max(max(diff_4));
% d1 = min(min(diff_4));
% e0 = max(max(qua));
% e1 = min(min(qua));
