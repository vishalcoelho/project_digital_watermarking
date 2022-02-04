close all;
clear all;
filename1=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\colortest.jpg'];
get(0,'ScreenDepth')
n=1;
figure();
input_image=imread(filename1);
imshow(input_image);
[x,map] = rgb2ind(input_image, n);
figure();
imshow(x);