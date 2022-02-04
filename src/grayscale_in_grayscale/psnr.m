%--------------------------------------------------------------------------
% Program   : PSNR
% Objective : Calculate the PSNR of an image
%--------------------------------------------------------------------------
clc;
clear all;
close all;
%--------------------------------------------------------------------------
%% Filenames
image_file_1=['C:\Watermark R6 GiG\test_image_2.gif'];
image_file_2=['C:\Watermark R6 GiG\Results\test_image_2p.gif'];
%--------------------------------------------------------------------------
img_1=imread(image_file_1);
img_2=imread(image_file_2);
figure;
subplot(1,2,1),imshow(img_1);
subplot(1,2,2),imshow(img_2);
%--------------------------------------------------------------------------
sum=0;
for i=1:512
    for j=1:512
        p1=double(img_1(i,j));
        p2=double(img_2(i,j));
        diff=abs(p1-p2);
        sum=sum+(diff*diff);
    end
end
MSE=sum/(512*512);
maxpix=255;
PSNR=10*log10((maxpix*maxpix)/MSE);
fprintf('The PSNR is %0.2f dBs\n',PSNR);
%--------------------------------------------------------------------------
%End of Code
%--------------------------------------------------------------------------


