%--------------------------------------------------------------------------
% Program   : Grayscale in grayscale watermarking
% Objective : Extract the hidden watermark
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
ownership_file=['C:\Watermark R6 GiG\ownershare.gif'];
key_file=['C:\Watermark R6 GiG\key.bin'];
mean_map_file=['C:\Watermark R6 GiG\meanmap.bin'];
stdev_map_file=['C:\Watermark R6 GiG\stdevmap.bin'];
%--------------------------------------------------------------------------
%% Globals
global n 
n=4;
%--------------------------------------------------------------------------
%% Stage 1: Scan the Transmitted (host) image
host_image=imread(histeq_host);  %format:  Unsigned integer 8 bits
%--------------------------------------------------------------------------
%% Stage 2: Scan the ownership share
owner_share=imread(ownership_file); %format: Logical 1 bit
%--------------------------------------------------------------------------
%% Stage 3: Read the Key
fid=fopen(key_file,'r');
key=fread(fid,'uint32'); %format: double
key=uint32(key);    %format: Unsigned integer 32 bits
fstatus=fclose(fid);
if fstatus==0
    fprintf('File "Key.bin" closed properly\n');
else
    fprintf('Unable to close file "Key.bin"\n');
end
%--------------------------------------------------------------------------
%% Stage 4: Read the mean and standard deviations map
fid=fopen(mean_map_file,'r');
mean_map=fread(fid,'uint32'); %format: double
mean_map=uint32(mean_map);    %format: Unsigned integer 32 bits
fstatus=fclose(fid);
if fstatus==0
    fprintf('File "Mean Map.bin" closed properly\n');
else
    fprintf('Unable to close file "Mean Map.bin"\n');
end
fid=fopen(stdev_map_file,'r');
stdev_map=fread(fid,'uint32'); %format: double
stdev_map=uint32(stdev_map);    %format: Unsigned integer 32 bits
fstatus=fclose(fid);
if fstatus==0
    fprintf('File "Stdev Map.bin" closed properly\n');
else
    fprintf('Unable to close file "Stdev Map.bin"\n');
end
%--------------------------------------------------------------------------
%% Stage 5: Bit plane of the watermark
permute_host=permute_img(host_image,key);
%The host image is permuted here because in the GiG program permutation was
%done before the bit plane was obtained
bit_host=bit_plane(permute_host);   %format: logical
bit_wmark=xor(bit_host,owner_share);
%--------------------------------------------------------------------------
%% Stage 6: Mean and Standard deviations of the permuted host image
host_mean=b_mean(permute_host);
%format: Unsigned integer 32 bits
host_stdev=b_stdev(permute_host);
%format: Unsigned integer 32 bits
%--------------------------------------------------------------------------
%% Stage 7: Mean and Standard deviations of the watermark
for i=1:16384
    wmark_mean(i)=host_mean(mean_map(i));   %format: Unsigned integer 32 bits
    wmark_stdev(i)=host_stdev(stdev_map(i)); %format: Unsigned integer 32 bits
end
%--------------------------------------------------------------------------
%% Stage 8: Recover the Grayscale Watermark
permute_wmark=recover(bit_wmark,wmark_mean,wmark_stdev);
%Incase watermark is permuted we use permute_wmark
wmark_image=inv_permute(permute_wmark,key);
% wmark_image=permute_wmark;
%--------------------------------------------------------------------------
%% Display
figure;imshow(host_image);
figure;imshow(owner_share);
figure;imshow(bit_host);
figure;imshow(bit_wmark);
figure;imshow(wmark_image);
%--------------------------------------------------------------------------
%% End of code
fprintf('End of the Extraction code\n');
%--------------------------------------------------------------------------
