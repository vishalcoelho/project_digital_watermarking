%--------------------------------------------------------------------------
%Program: Extracting the Watermark after BTC
%--------------------------------------------------------------------------
clc;
close all;
clear all;
%--------------------------------------------------------------------------
%% Globals
global block_count block_mean block_stddev
block_count=1;
%--------------------------------------------------------------------------
%% Filenames
Filename1=['C:\Watermark Binary BTC\lena.gif'];
Filename2=['C:\Watermark Binary BTC\Ownership_share1.gif'];
Filename3=['C:\Watermark Binary BTC\Ownership_share2.gif'];
% Ownership shares
Filename4=['C:\Watermark Binary BTC\permute_key.bin'];
% Permutation matrix
Filename5=['C:\Watermark Binary BTC\selection.bin'];
% Selection choice
Filename6=['C:\Watermark Binary BTC\Extracted_wmark.gif'];
jpeg_image_file=['C:\Watermark Binary BTC\lena.jpg'];
%--------------------------------------------------------------------------
%% Function Handles
fhandle1=@Bit_plane_generate;
%--------------------------------------------------------------------------
%% Image 2

%% Attacks

test_img=imread(Filename1);
test_img=im2double(test_img);
fprintf('\t\tAttacks\n\t1. Cropping\n\t2. Rotation\n\t3. Additive White Gaussian Noise');
fprintf('\n\t4. JPEG Compression\n\t5. Scaling\n');
choice=input('Enter your choice: ');
switch choice
    case 1
        Input_image=crop_attack(test_img);
    case 2
        Input_image=rotate_attack(test_img);
    case 3
        Input_image=awgn_attack(test_img);
    case 4
        Input_image=imread(jpeg_image_file);
    case 5
        Input_image=scale_attack(test_img);
    otherwise
        Input_image=test_img;
end
%--------------------------------------------------------------------------
%Read the Ownership share
Ownership_share=imread(Filename2);
Ownership_share=logical(Ownership_share);
%--------------------------------------------------------------------------
%% Permute host image
[index_x index_y]=size(Ownership_share);
file_id=fopen(Filename4,'r');
Permute_matrix=fread(file_id,'uint32');
fclose(file_id);
file_id=fopen(Filename5,'r');
sel=fread(file_id,'uint32');
fclose(file_id);

Permute_image=impermute(Input_image,Permute_matrix,sel);
% for i=1:index_x
%     for j=1:index_y
%         x_coordinate=uint32(Permute_matrix((i-1)*index_x+j)/index_x);
%         if x_coordinate==0;
%             x_coordinate=1;
%         end
%         y_coordinate=mod(Permute_matrix((i-1)*index_x+j),index_x);
%         if y_coordinate==0
%             y_coordinate=index_x;
%         end
%         Permute_image1(i,j)=Input_image1(x_coordinate,y_coordinate);
%         Permute_image2(i,j)=Input_image2(x_coordinate,y_coordinate);
%         Permute_image3(i,j)=Input_image3(x_coordinate,y_coordinate);
%         Permute_image4(i,j)=Input_image4(x_coordinate,y_coordinate);
%     end
% end
%--------------------------------------------------------------------------
%% Generate bit plane of the Host image
Bit_plane_image=blkproc(Permute_image,[4,4],fhandle1);
Bit_plane_image=logical(Bit_plane_image);

% Bit_plane_image2=blkproc(Permute_image2,[4,4],fhandle1);
% Bit_plane_image2=logical(Bit_plane_image2);
% Bit_plane_image3=blkproc(Permute_image3,[4,4],fhandle1);
% Bit_plane_image3=logical(Bit_plane_image3);
% Bit_plane_image4=blkproc(Permute_image4,[4,4],fhandle1);
% Bit_plane_image4=logical(Bit_plane_image4);

%--------------------------------------------------------------------------
%% "Extract" the watermark
Watermark=xor(Ownership_share,Bit_plane_image);
Watermark=Watermark(1:128,1:128);
imwrite(Watermark,Filename6,'tiff');
% Watermark1_2=xor(Ownership_share1,Bit_plane_image2);
% Watermark1_3=xor(Ownership_share1,Bit_plane_image3);
% Watermark1_4=xor(Ownership_share1,Bit_plane_image4);
% 
% Watermark2_1=xor(Ownership_share2,Bit_plane_image1);
% Watermark2_2=xor(Ownership_share2,Bit_plane_image2);
% Watermark2_3=xor(Ownership_share2,Bit_plane_image3);
% Watermark2_4=xor(Ownership_share2,Bit_plane_image4);
%--------------------------------------------------------------------------
%% Display Watermark
close;
figure,imshow(Watermark);
% subplot(1,4,1),imshow(Watermark1_1);
% subplot(1,4,2),imshow(Watermark1_2);
% subplot(1,4,3),imshow(Watermark1_3);
% subplot(1,4,4),imshow(Watermark1_4);
% 
% close;figure;
% subplot(1,4,1),imshow(Watermark2_1);
% subplot(1,4,2),imshow(Watermark2_2);
% subplot(1,4,3),imshow(Watermark2_3);
% subplot(1,4,4),imshow(Watermark2_4);
%--------------------------------------------------------------------------
% End of Code
%--------------------------------------------------------------------------



