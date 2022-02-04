%--------------------------------------------------------------------------
% Program   : Color Extract
%--------------------------------------------------------------------------
%% Functions
%1. impermute.m
%2. bps.m
%3. btc.mc
%--------------------------------------------------------------------------
clc;
close all;
clear all;
%--------------------------------------------------------------------------
%% Filenames
host_img_file=['C:\Watermark R9\Test_host_7.gif'];
jpeg_image_file=['C:\Watermark R9\Test_host_7.jpg'];
oshare_file=['C:\Watermark R9\oshare.gif'];
key_file=['C:\Watermark R9\key.bin'];
prm_sel_file=['C:\Watermark R9\prm_sel.bin'];
ext_wmark_file=['C:\Watermark R9\ext_wmark.jpg'];
%--------------------------------------------------------------------------
%% Attacks
%% Stage 1: Read images
test_img=imread(host_img_file);
oship_share=imread(oshare_file);
fprintf('\t\tAttacks\n\t1. Cropping\n\t2. Rotation\n\t3. Additive White Gaussian Noise');
fprintf('\n\t4. JPEG Compression\n\t5. Scaling\n');
choice=input('Enter your choice: ');
switch choice
    case 1
        host_img=crop_attack(test_img);
    case 2
        host_img=rotate_attack(test_img);
    case 3
        host_img=awgn_attack(test_img);
    case 4
        host_img=imread(jpeg_image_file);
    case 5
        host_img=scale_attack(test_img);
    otherwise
        host_img=test_img;
end
%--------------------------------------------------------------------------
%% Stage 2: Read the key and permutation choice
fid=fopen(key_file,'r');
prm_key=fread(fid,'double');
fclose(fid);
prm_key=(prm_key)';     % Transposing the vector
fid=fopen(prm_sel_file,'r');
prm_sel=fread(fid);
fclose(fid);
%--------------------------------------------------------------------------
%% Stage 3: Permute the Host image
prm_host_img=impermute(host_img,prm_key,prm_sel);
%--------------------------------------------------------------------------
%% Stage 4: BTC of Host image
bps_host_img=btc(prm_host_img);
%--------------------------------------------------------------------------
%% Stage 5: Xor'ing
bps_wmark_img=xor(bps_host_img,oship_share);
%--------------------------------------------------------------------------
%% Stage 6: Inverse bit plane seperation
wmark_img=ibps(bps_wmark_img);
imwrite(wmark_img,ext_wmark_file,'jpg');
%--------------------------------------------------------------------------
%% Stage 7: Display
figure,imshow(host_img);
figure,imshow(oship_share);
figure,imshow(prm_host_img);
figure,imshow(bps_wmark_img);
figure,imshow(bps_host_img);
figure,imshow(wmark_img);   
%--------------------------------------------------------------------------
% End of Code
%--------------------------------------------------------------------------