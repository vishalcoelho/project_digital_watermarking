%--------------------------------------------------
%Program: Reconstructing the BTC compressed image
%--------------------------------------------------

clc;
close all;
clear all;

%% Function Handles
fhandle1=@Recon;

%% Globals
global block_count block_mean block_stddev
block_count=1;

%% Filenames
Filename1=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3-1\bit_plane.gif'];
Filename2=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3-1\block_mean.bin'];
Filename3=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3-1\block_stddev.bin'];
Filename4=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3-1\Recon_image.gif'];
% Taking original just for comparision sake
Filename5=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3-1\cat.gif'];
Filename6=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3-1\permute_key.bin'];
% Permutation matrix

%% Read Image and Statistical Parameters
Bit_plane_image=imread(Filename1);

file_id=fopen(Filename2,'r');
block_mean=fread(file_id,'double');
fclose(file_id);

file_id=fopen(Filename3,'r');
block_stddev=fread(file_id,'double');
fclose(file_id);

Input_image=imread(Filename5);
Input_image=im2double(Input_image);

%% Reconstructing the image
Permute_image=blkproc(Bit_plane_image,[4,4],fhandle1);

%% Inverse Permute host image
[index_x index_y]=size(Input_image);
file_id=fopen(Filename6,'r');
Permute_matrix=fread(file_id,'uint32');
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
        Recon_image(i,j)=Permute_image(x_coordinate,y_coordinate);
    end
end


%% Displaying images
close;figure;
subplot(1,2,1),imshow(Input_image);
subplot(1,2,2),imshow(Recon_image);

%% Saving files
imwrite(Recon_image,Filename4,'tiff');