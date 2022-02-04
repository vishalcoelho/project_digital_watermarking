%--------------------------------------------------------------------------
%Program: Watermarking using Block Truncation Coding
%--------------------------------------------------------------------------

clc;
close all;
clear all;

%% Global Variables
global block_count 
global block_mean block_stddev
block_count=1;

%% Function Handles
fhandle1=@Bit_plane_generate;

%% Filenames
Filename1=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\lena.gif'];
%Host Image
Filename2=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\watermark.gif'];
%Watermark
Filename3=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\watermark3.bmp'];
%Watermark
Filename4=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\Ownership_share1.gif'];
%Ownership share 
Filename5=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\Ownership_share2.gif'];
%Ownership share 
Filename6=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\bit_plane.gif'];
%Bit plane image
Filename7=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\block_mean.gif'];
%Block mean of host image
Filename8=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\block_stddev.gif'];
%Block standard deviation of host image
Filename9=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\permute_key.bin'];
%Permutation matrix

%% Image Read
%Read the Host Image
Input_image=imread(Filename1);
Input_image=im2double(Input_image);

%Read the Watermark
Watermark1=imread(Filename2);
Watermark1=logical(Watermark1);

Watermark2=imread(Filename3);
Watermark2=logical(Watermark2);

%Test Code
% figure();
% imshow(Input_image);
% figure;
% imshow(Watermark);

%% Permuting the Image using PseudoRandom Code
%% Watermark Permutation 
%Watermark permutation is done to disperse the spatial relationship of the
%binary watermark
[index_x index_y]=size(Input_image);
Permute_matrix=randperm(index_x*index_y);
file_id=fopen(Filename9,'w+');
fwrite(file_id,Permute_matrix,'uint32');
fclose(file_id);
for i=1:index_x
    for j=1:index_y
        x_coordinate=uint32(Permute_matrix((i-1)*index_x+j)/index_x);
        if x_coordinate==0;
            x_coordinate=1;
        end
        y_coordinate=mod(Permute_matrix((i-1)*index_x+j),index_x);
        if y_coordinate==0
            y_coordinate=index_x;
        end
        Permute_image(i,j)=Input_image(x_coordinate,y_coordinate);
    end
end
%NOTE: randperm() doesnt have an inverse operation therefore,
%Permute_matrix must be known to the user inorder to generate the watermark
%This is a drawback as it presents a point of attack to an opponent



%% Generating the Bit Plane
Bit_plane_image=blkproc(Permute_image,[4,4],fhandle1);
Bit_plane_image=logical(Bit_plane_image);
%We process the host image 4x4 blocks at a time, each time returning the 
%equivalent bit plane corresponding to the block. The function used here is
%Bit_plane_generate.m

%% Generating the ownership share
Ownership_share1=xor(Bit_plane_image,Watermark1);
Ownership_share2=xor(Bit_plane_image,Watermark2);

%% Writing Images and Statistical Arrays

% NOTE: If compression is required then the bit image, block means and
% standard deviations are written to file and transferred. Our objective
% here is to simply watermark the image, therefore only the ownership share
% is written to file.

imwrite(Ownership_share1,Filename4,'tiff');
imwrite(Ownership_share2,Filename5,'tiff');
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
    
%% Demonstration
close;figure;imshow(Input_image);
close;figure;imshow(Watermark1);
close;figure;imshow(Watermark2);
close;figure;imshow(Bit_plane_image);
close;figure;imshow(Ownership_share1);
close;figure;imshow(Ownership_share2);




