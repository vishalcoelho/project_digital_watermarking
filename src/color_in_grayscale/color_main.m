%--------------------------------------------------------------------------
% Program   : Color Watermarking
%--------------------------------------------------------------------------
%% Functions
%1. impermute.m
%2. bps.m
%3. btc.m
%4. keygen.m
%--------------------------------------------------------------------------
clc;
clear all;
close all;
%--------------------------------------------------------------------------
%% Filenames
host_img_file=['C:\Watermark R9\Test_host_7.gif'];
wmark_img_file=['C:\Watermark R9\wolf4.jpg'];
orig_wmark_img_file=['C:\Watermark R9\orig_wmark.jpg'];
oshare_file=['C:\Watermark R9\oshare.gif'];
key_file=['C:\Watermark R9\key.bin'];
prm_sel_file=['C:\Watermark R9\prm_sel.bin'];
%--------------------------------------------------------------------------
%% Stage 1: Read the images
host_img=imread(host_img_file); %format : uint8
wmark_img=imread(wmark_img_file);
%--------------------------------------------------------------------------
%% Stage 2: Permute the Host, save the key
[prm_key prm_sel]=keygen(host_img);
prm_host_img=impermute(host_img,prm_key,prm_sel);
fid=fopen(key_file,'w+');
fwrite(fid,prm_key,'double');
fclose(fid);
fid=fopen(prm_sel_file,'w+');
fwrite(fid,prm_sel);
fclose(fid);
%--------------------------------------------------------------------------
%% Stage 3: Bit plane separation
bps_wmark_img=bps(wmark_img);
%--------------------------------------------------------------------------
%% Stage 4: BTC of host image
bps_host_img=btc(prm_host_img);
%--------------------------------------------------------------------------
%% Stage 5: Ownership share
oship_share=xor(bps_host_img,bps_wmark_img);
%--------------------------------------------------------------------------
%% Stage 6: Write to file
imwrite(oship_share,oshare_file,'tiff');
imwrite(wmark_img,orig_wmark_img_file,'jpg');
%--------------------------------------------------------------------------
%% Stage n: Display images
figure,imshow(host_img);
figure,imshow(wmark_img);   
figure,imshow(prm_host_img);
figure,imshow(bps_wmark_img);
figure,imshow(bps_host_img);
figure,imshow(oship_share);
%--------------------------------------------------------------------------
% End of Code
%--------------------------------------------------------------------------