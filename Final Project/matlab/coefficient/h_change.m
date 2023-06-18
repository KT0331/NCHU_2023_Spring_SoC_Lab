clear all
close all
clc

h = [ 0.037828455507
      0.023849465020
      0.110624404418
      0.377402855613
      0.852698679009
      0.377402855613
      0.110624404418
      0.023849465020
      0.037828455507];

h_fixed=zeros(9 ,10);

fid = fopen('h_fixed.txt','wt');

for i = 1 : 9
    y=h(i);
    for j = 1:11
        y=y*2;
        h_fixed(i,j)=floor(y);
        if j == 4
            fprintf(fid ,'%d_' ,h_fixed(i,j));
        elseif j == 8
            fprintf(fid ,'%d_' ,h_fixed(i,j));
        else
            fprintf(fid ,'%d' ,h_fixed(i,j));
        end
        
        if y > 1
            y = y - 1;
        else
            y = y;
        end
    end
    fprintf(fid ,'\n');
end

fclose(fid);