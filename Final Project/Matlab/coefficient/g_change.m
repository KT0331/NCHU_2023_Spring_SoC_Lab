clear all
close all
clc

g = [ 0.064538882629
      0.040689417609
      0.418092273222
      0.788485616406
      0.418092273222
      0.040689417609
      0.064538882629];

g_fixed=zeros(7 ,10);

fid = fopen('g_fixed.txt','wt');

for i = 1 : 7
    y=g(i);
    for j = 1:11
        y=y*2;
        g_fixed(i,j)=floor(y);
        if j == 4
            fprintf(fid ,'%d_' ,g_fixed(i,j));
        elseif j == 8
            fprintf(fid ,'%d_' ,g_fixed(i,j));
        else
            fprintf(fid ,'%d' ,g_fixed(i,j));
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