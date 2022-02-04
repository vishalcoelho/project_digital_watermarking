%--------------------------------------------------------------------------
% Program   : Color PSNR
%--------------------------------------------------------------------------
clc;
clear all;
close all;
%--------------------------------------------------------------------------
%% Filenames
wmark_img_file=['C:\Watermark R9\orig_wmark.jpg'];
ext_wmark_file=['C:\Watermark R9\ext_wmark.jpg'];
%--------------------------------------------------------------------------
%% Stage 1: Read the images
img_1=imread(wmark_img_file);
img_2=imread(ext_wmark_file);
%--------------------------------------------------------------------------
%% Stage 2: Display the images
figure;
subplot(1,2,1),imshow(img_1);
subplot(1,2,2),imshow(img_2);
%--------------------------------------------------------------------------
%% Stage 3: Convert to YCbCr
ycbcr_img_1 = rgb2ycbcr(img_1);
ycbcr_img_2 = rgb2ycbcr(img_2);
[ind_x ind_y ind_z]=size(img_1);
for i=1:ind_x
    for j=1:ind_y
        y_img_1(i,j)=ycbcr_img_1(i,j,1);
        y_img_2(i,j)=ycbcr_img_2(i,j,1);
    end
end
%--------------------------------------------------------------------------
%% Stage 4: Calculate the MSE
sum=0;
for i=1:ind_x
    for j=1:ind_y
        p1=double(y_img_1(i,j));
        p2=double(y_img_2(i,j));
        diff=abs(p1-p2);
        sum=sum+(diff*diff);
    end
end
MSE=sum/(ind_x*ind_y);
fprintf('The MSE is %0.2f\n',MSE);
%--------------------------------------------------------------------------
%% Stage 5: PSNR
maxpix=255;
PSNR=10*log10((maxpix*maxpix)/MSE);
fprintf('The PSNR is %0.2f dBs\n',PSNR);
%--------------------------------------------------------------------------
% End of Code
%--------------------------------------------------------------------------