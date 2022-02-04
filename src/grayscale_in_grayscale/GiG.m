%--------------------------------------------------------------------------
% Program   : Grayscale in grayscale watermarking
% Objective : Hiding a grayscale image in another grayscale image using BTC
%             watermarking technique
%--------------------------------------------------------------------------
% Functions : 1.bit_plane.m
%             2.b_mean.m
%             3.b_stdev.m
%             4.permute_img.m
%             5.inv_permute.m
%--------------------------------------------------------------------------
clc;
close all;
clear all;
%--------------------------------------------------------------------------
%% Filenames
image_file=['C:\Watermark R6 GiG\test_image_2.gif'];
histeq_host=['C:\Watermark R6 GiG\histeq_host_image.gif'];
watermark_file=['C:\Watermark R6 GiG\test_image_3.gif'];
ownership_file=['C:\Watermark R6 GiG\ownershare.gif'];
key_file=['C:\Watermark R6 GiG\key.bin'];
mean_map_file=['C:\Watermark R6 GiG\meanmap.bin'];
stdev_map_file=['C:\Watermark R6 GiG\stdevmap.bin'];
%--------------------------------------------------------------------------
%% Globals
global n 
n=4;
%--------------------------------------------------------------------------
%% Stage 1: Scan the image
host_image=imread(image_file);  %format: unsigned integer 8 bits
host_image=histeq(host_image);
imwrite(host_image,histeq_host,'tiff');
wmark_image=imread(watermark_file); %format: unsigned integer 8 bits
%--------------------------------------------------------------------------
%% Stage 2: Permute the image
key=uint32(randperm(512*512));  %format: unsigned integer 32 bits
fid=fopen(key_file,'w');    
fwrite(fid,key,'uint32');   %format: Unsigned integer 32 bits
fstatus=fclose(fid);
if fstatus==0
    fprintf('File "Key.bin" closed properly\n');
else
    fprintf('Unable to close file "Key.bin"\n');
end
permute_host=permute_img(host_image,key);%format: Unsigned integer 8 bits
permute_wmark=permute_img(wmark_image,key);  %Permutation may be required for watermark
% permute_wmark=wmark_image;
%--------------------------------------------------------------------------
%% Test Code
% host_image=inv_permute(permute_host);%format: Unsigned integer 8 bits
% figure;imshow(host_image);
% wmark_image=inv_permute(permute_wmark);%format: Unsigned integer 8 bits
% figure;imshow(wmark_image);
%--------------------------------------------------------------------------
%% Stage 3: Bit planes
bit_host=bit_plane(permute_host);
bit_wmark=bit_plane(permute_wmark);
%--------------------------------------------------------------------------
%% Stage 4: Ownership share
owner_share=xor(bit_host,bit_wmark);
imwrite(owner_share,ownership_file,'tiff');
%--------------------------------------------------------------------------
%% Stage 5: Mean and Standard deviation of host and watermark
host_mean=b_mean(permute_host);
wmark_mean=b_mean(permute_wmark);
host_stdev=b_stdev(permute_host);
wmark_stdev=b_stdev(permute_wmark);
%--------------------------------------------------------------------------
%% Stage 6: Vector map
mean_map=vec_map(wmark_mean,host_mean);
stdev_map=vec_map(wmark_stdev,host_stdev);
%--------------------------------------------------------------------------
%% Stage 7: Write Vector map to file
fid=fopen(mean_map_file,'w');
fwrite(fid,mean_map,'uint32');   %format: Unsigned integer 32 bits
fstatus=fclose(fid);
if fstatus==0
    fprintf('File "Mean Map.bin" closed properly\n');
else
    fprintf('Unable to close file "Mean Map.bin"\n');
end
fid=fopen(stdev_map_file,'w');
fwrite(fid,stdev_map,'uint32');   %format: Unsigned integer 32 bits
fstatus=fclose(fid);
if fstatus==0
    fprintf('File "Stdev Map.bin" closed properly\n');
else
    fprintf('Unable to close file "Stdev Map.bin"\n');
end
%--------------------------------------------------------------------------
%% Test Code
for i=1:16384
    mean_index=mean_map(i);
    stdev_index=stdev_map(i);
    temp_mean(i)=host_mean(mean_index);
    temp_stdev(i)=host_stdev(stdev_index);
end
%--------------------------------------------------------------------------
%% Display
figure;imshow(host_image);
figure;imshow(wmark_image);
figure;imshow(permute_host);
figure;imshow(bit_host);
figure;imshow(bit_wmark);
figure;imshow(owner_share);
figure;
i=1:16384;
subplot(2,1,1),plot(i,temp_mean,'ms',i,wmark_mean,'-b');
legend('Mapped mean','Watermark mean');
subplot(2,1,2),plot(i,temp_stdev,'ms',i,wmark_stdev,'-b');
legend('Mapped Stdev','Watermark stdev');
%--------------------------------------------------------------------------
%% End of code
fprintf('End of the GiG code\n');
%--------------------------------------------------------------------------