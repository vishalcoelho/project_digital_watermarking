%--------------------------------------------------------------------------
% Program   : Extraction of Watermark
%--------------------------------------------------------------------------
clc;
close all;
clear all;
%--------------------------------------------------------------------------
%% Filenames
host_img_file=['C:\Project\Binary DCT\Images\lena.gif'];
output_img_file=['C:\Project\Binary DCT\Images\output_img.gif'];
ext_wmark_file=['C:\Project\Binary DCT\Images\ext_wmark.gif'];
jpeg_img_file=['C:\Project\Binary DCT\Images\lena.jpg'];
prm_key_file=['C:\Project\Binary DCT\Binaries\prm_key.bin'];
signbits_key_file=['C:\Project\Binary DCT\Binaries\signbits_key.bin'];
varmap_key_file=['C:\Project\Binary DCT\Binaries\varmap_key.bin'];
%--------------------------------------------------------------------------
%% Attacks
%% Stage 1: Read images
test_img=imread(host_img_file);
output_img=imread(output_img_file);
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
        host_img=imread(jpeg_img_file);
    case 5
        host_img=scale_attack(test_img);
    otherwise
        host_img=test_img;
end
host_img=im2double(host_img);
output_img=im2double(output_img);
%--------------------------------------------------------------------------
%% Stage 1: DCT of images
blk_sz=8;
fhandle=@dct2;
host_dct_img=blkproc(host_img,[blk_sz,blk_sz],fhandle);
output_dct_img=blkproc(output_img,[blk_sz,blk_sz],fhandle);
%--------------------------------------------------------------------------
%% Stage 2: Reducing the coeffs
fhandle=@Dct_reduce_matrix;
dct_host_midcoeff=blkproc(host_dct_img,[blk_sz,blk_sz],fhandle);
dct_output_midcoeff=blkproc(output_dct_img,[blk_sz,blk_sz],fhandle);
%--------------------------------------------------------------------------
%% Stage 3: Binary Polarity Pattern
% Find polarity pattern of reduced dct matrices
polar_host_matrix=Polarity_pattern(dct_host_midcoeff);
for i=1:128
    for j=1:128
        curr=dct_output_midcoeff(i,j);
        prev=dct_host_midcoeff(i,j);
        if curr>prev
            polar_output_matrix(i,j)=0;
        else
            polar_output_matrix(i,j)=1;
        end
    end
end
polar_host_matrix=logical(polar_host_matrix);
polar_output_matrix=logical(polar_output_matrix);

%--------------------------------------------------------------------------
%% Stage 4: Extract the block permuted watermark
prm_wmark_img=xor(polar_host_matrix,polar_output_matrix);
%--------------------------------------------------------------------------
%% Stage 5: Reverse map using variance map key
fid=fopen(varmap_key_file);
prm_key=fread(fid,'uint32');
fclose(fid);
prm_wmark_img=rev_blk_permute(prm_wmark_img,prm_key);
%--------------------------------------------------------------------------
%% Stage 6: Reverse map using sign bits key
fid=fopen(signbits_key_file);
prm_key=fread(fid,'uint32');
fclose(fid);
prm_wmark_img=rev_blk_permute(prm_wmark_img,prm_key);
%--------------------------------------------------------------------------
%% Stage 7: Inverse permute the image
fid=fopen(prm_key_file,'r');
prm_key=fread(fid,'uint32');
fclose(fid);
wmark_img=rev_pix_permute(prm_wmark_img,prm_key);
imwrite(wmark_img,ext_wmark_file,'tiff');
%--------------------------------------------------------------------------
%% Stage 8: Display
host_img=im2uint8(host_img);
figure,imshow(host_img);
figure;imshow(wmark_img);
%--------------------------------------------------------------------------

% End of Code
%--------------------------------------------------------------------------