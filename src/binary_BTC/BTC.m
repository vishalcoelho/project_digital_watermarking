%--------------------------------------------------------------------------
%Program: Watermarking using Block Truncation Coding
%--------------------------------------------------------------------------
clc;
close all;
clear all;
%--------------------------------------------------------------------------
%% Global Variables
global block_count
global block_mean block_stddev
block_count=1;
%--------------------------------------------------------------------------
%% Function Handles
fhandle1=@Bit_plane_generate;
%--------------------------------------------------------------------------
%% Filenames
Filename1=['C:\Watermark Binary BTC\lena.gif'];
%Host Image
Filename2=['C:\Watermark Binary BTC\watermark.gif'];
%Watermark
Filename3=['C:\Watermark Binary BTC\watermark3.bmp'];
%Watermark
Filename4=['C:\Watermark Binary BTC\Ownership_share1.gif'];
%Ownership share
Filename5=['C:\Watermark Binary BTC\Ownership_share2.gif'];
%Ownership share
Filename6=['C:\Watermark Binary BTC\bit_plane.gif'];
%Bit plane image
Filename7=['C:\Watermark Binary BTC\block_mean.bin'];
%Block mean of host image
Filename8=['C:\Watermark Binary BTC\block_stddev.bin'];
%Block standard deviation of host image
Filename9=['C:\Watermark Binary BTC\permute_key.bin'];
%Permutation matrix
Filename10=['C:\Watermark Binary BTC\selection.bin'];
%Selection choice
%--------------------------------------------------------------------------
%% Image Read
%Read the Host Image
Input_image=imread(Filename1);
Input_image=im2double(Input_image);
%--------------------------------------------------------------------------
%Read the Watermark and pad if necessary
Watermark=imread(Filename2);
[sz_x sz_y]=size(Watermark);
% for i=1:sz_x
%     for j=1:sz_y
%         pix=Watermark(i,j);
%         if pix==255
%             op=1;
%         elseif pix==40
%             op=0;
%         else
%             ;
%         end
%         Watermark(i,j)=op;
%     end
% end
Watermark=logical(Watermark);
[sz_x sz_y]=size(Input_image);
Watermark=impad(Watermark,sz_x,sz_y);
%--------------------------------------------------------------------------
%Test Code
% figure();
% imshow(Input_image);
% figure;
% imshow(Watermark);

[key sel]=keygen(Input_image);
Permute_image=impermute(Input_image,key,sel);

%% Permuting the Image using PseudoRandom Code
%% Watermark Permutation
%Watermark permutation is done to disperse the spatial relationship of the
%binary watermark
% [index_x index_y]=size(Input_image);
% Permute_matrix=randperm(index_x*index_y);

file_id=fopen(Filename9,'w+');
fwrite(file_id,key,'uint32');
fclose(file_id);
file_if=fopen(Filename10,'w+');
fwrite(file_id,sel,'uint32');
fclose(file_id);

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
%         Permute_image(i,j)=Input_image(x_coordinate,y_coordinate);
%     end
% end
%NOTE: randperm() doesnt have an inverse operation therefore,
%Permute_matrix must be known to the user inorder to generate the watermark
%This is a drawback as it presents a point of attack to an opponent
%--------------------------------------------------------------------------
%% Generating the Bit Plane
Bit_plane_image=blkproc(Permute_image,[4,4],fhandle1);
Bit_plane_image=logical(Bit_plane_image);
%We process the host image 4x4 blocks at a time, each time returning the
%equivalent bit plane corresponding to the block. The function used here is
%Bit_plane_generate.m
%--------------------------------------------------------------------------
%% Generating the ownership share
Ownership_share=xor(Bit_plane_image,Watermark);
%--------------------------------------------------------------------------
%% Writing Images and Statistical Arrays

% NOTE: If compression is required then the bit image, block means and
% standard deviations are written to file and transferred. Our objective
% here is to simply watermark the image, therefore only the ownership share
% is written to file.

imwrite(Ownership_share,Filename4,'tiff');
imwrite(Bit_plane_image,Filename6,'tiff');
file_id=fopen(Filename7,'w+');
fwrite(file_id,block_mean,'double');
file_status=fclose(file_id);

if file_status==0
    disp('File block_mean has been closed properly');
else
    disp('File block_mean has not been closed properly');
end

file_id=fopen(Filename8,'w+');
fwrite(file_id,block_stddev,'double');
file_status=fclose(file_id);

if file_status==0
    disp('File block_stddev has been closed properly');
else
    disp('File block_stddev has not been closed properly');
end
%--------------------------------------------------------------------------
%% Demonstration
close;figure;
subplot(1,2,1),imshow(Input_image);
subplot(1,2,2),imshow(Bit_plane_image);
figure;
subplot(1,2,1),imshow(Watermark);
subplot(1,2,2),imshow(Ownership_share);
%--------------------------------------------------------------------------
% End of Code
%--------------------------------------------------------------------------


