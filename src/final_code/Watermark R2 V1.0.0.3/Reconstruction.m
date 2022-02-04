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
Filename1=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\bit_plane.gif'];
Filename2=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\block_mean.bin'];
Filename3=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\block_stddev.bin'];
Filename4=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\Recon_image.gif'];

%% Read Image and Statistical Parameters
Bit_plane_image=imread(Filename1);
file_id=fopen(Filename2,'r');
block_mean=fread(file_id,'double');
fclose(file_id);

file_id=fopen(Filename3,'r');
block_stddev=fread(file_id,'double');
fclose(file_id);

%% Reconstructing the image
Recon_image=blkproc(Bit_plane_image,[4,4],fhandle1);

%% Displaying images
close;figure;imshow(Recon_image);

%% Saving files
imwrite(Recon_image,Filename4,'tiff');