clear all
close all
clc

h_floating = [ 0.037828455507
              -0.023849465020
              -0.110624404418
               0.377402855613
               0.852698679009
               0.377402855613
              -0.110624404418
              -0.023849465020
               0.037828455507];

g_floating = [-0.064538882629
               0.040689417609
               0.418092273222
              -0.788485616406
               0.418092273222
               0.040689417609
              -0.064538882629];

%Fixed point coefficients
h = fi(h_floating ,1 ,11 ,10);
g = fi(g_floating ,1 ,11 ,10);

fid = fopen('h_fixed.txt','wt');
for i = 1 : 9
    fprintf(fid ,'%s' ,bin(h(i)));
    fprintf(fid ,'\n');
end
fclose(fid);

fid1 = fopen('g_fixed.txt','wt');
for i = 1 : 7
    fprintf(fid1 ,'%s' ,bin(g(i)));
    fprintf(fid1 ,'\n');
end
fclose(fid1);