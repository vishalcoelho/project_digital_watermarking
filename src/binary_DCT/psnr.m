%--------------------------------------------------------------------------
% Program   : PSNR
% Objective : Calculate the PSNR of an image
%--------------------------------------------------------------------------
clc;
clear all;
close all;
%--------------------------------------------------------------------------
%% Filenames
image_file_1=['C:\Project\Binary DCT\Images\rev_polar_matrix.tif'];
image_file_2=['C:\Project\Binary DCT\Images\polar_output_matrix.tif'];
%--------------------------------------------------------------------------
img_1=imread(image_file_1);
img_1=im2uint8(img_1);
img_2=imread(image_file_2);
img_2=im2uint8(img_2);
[ind_x ind_y]=size(img_1);
figure;
subplot(1,2,1),imshow(img_1);
subplot(1,2,2),imshow(img_2);
%--------------------------------------------------------------------------
sum=0;
for i=1:ind_x
    for j=1:ind_y
        p1=double(img_1(i,j));
        p2=double(img_2(i,j));
        diff=abs(p1-p2);
        sum=sum+(diff*diff);
    end
end
MSE=sum/(ind_x*ind_y);
maxpix=255;
PSNR=10*log10((maxpix*maxpix)/MSE);
fprintf('The MSE is %0.2f\n',MSE);
fprintf('The PSNR is %0.2f dBs\n',PSNR);
%--------------------------------------------------------------------------
%End of Code
%--------------------------------------------------------------------------


