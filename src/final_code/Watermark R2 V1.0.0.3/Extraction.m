%--------------------------------------------------------------------------
%Program: Extracting the Watermark after BTC
%--------------------------------------------------------------------------

clc;
close all;
clear all;

%% Globals
global block_count block_mean block_stddev
block_count=1;


%% Filenames
Filename1=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\lena.gif'];
Filename2=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\Ownership_share1.gif'];
Filename3=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\Ownership_share2.gif'];
% Ownership shares
Filename4=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\permute_key.bin'];
% Permutation matrix

%% Attacks
%Attack1: BTC Reconstructed image used to get bit plane for extraction purposes  
Filename5=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\Recon_image.gif'];
%Attack2: Cropping
Filename6=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\cropped_image.gif'];
%Attack3: Scaling
Filename7=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.3\scaled_image.gif'];

%% Function Handles
fhandle1=@Bit_plane_generate;

%% Image Read
%Read the Host Image
Input_image1=imread(Filename1);
Input_image1=im2double(Input_image1);
Input_image2=imread(Filename5);
Input_image2=im2double(Input_image2);
Input_image3=imread(Filename6);
Input_image3=im2double(Input_image3);
Input_image4=imread(Filename7);
Input_image4=im2double(Input_image4);

%Read the Ownership share
Ownership_share1=imread(Filename2);
Ownership_share1=logical(Ownership_share1);

Ownership_share2=imread(Filename3);
Ownership_share2=logical(Ownership_share2);

%% Permute host image
[index_x index_y]=size(Ownership_share1);
file_id=fopen(Filename4,'r');
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
        Permute_image1(i,j)=Input_image1(x_coordinate,y_coordinate);
        Permute_image2(i,j)=Input_image2(x_coordinate,y_coordinate);
        Permute_image3(i,j)=Input_image3(x_coordinate,y_coordinate);
        Permute_image4(i,j)=Input_image4(x_coordinate,y_coordinate);
    end
end
%% Generate bit plane of the Host image
Bit_plane_image1=blkproc(Permute_image1,[4,4],fhandle1);
Bit_plane_image1=logical(Bit_plane_image1);
Bit_plane_image2=blkproc(Permute_image2,[4,4],fhandle1);
Bit_plane_image2=logical(Bit_plane_image2);
Bit_plane_image3=blkproc(Permute_image3,[4,4],fhandle1);
Bit_plane_image3=logical(Bit_plane_image3);
Bit_plane_image4=blkproc(Permute_image4,[4,4],fhandle1);
Bit_plane_image4=logical(Bit_plane_image4);

%% "Extract" the watermark
Watermark1_1=xor(Ownership_share1,Bit_plane_image1);
Watermark1_2=xor(Ownership_share1,Bit_plane_image2);
Watermark1_3=xor(Ownership_share1,Bit_plane_image3);
Watermark1_4=xor(Ownership_share1,Bit_plane_image4);

Watermark2_1=xor(Ownership_share2,Bit_plane_image1);
Watermark2_2=xor(Ownership_share2,Bit_plane_image2);
Watermark2_3=xor(Ownership_share2,Bit_plane_image3);
Watermark2_4=xor(Ownership_share2,Bit_plane_image4);

%% Display Watermark
close;figure;
subplot(1,4,1),imshow(Watermark1_1);
subplot(1,4,2),imshow(Watermark1_2);
subplot(1,4,3),imshow(Watermark1_3);
subplot(1,4,4),imshow(Watermark1_4);

close;figure;
subplot(1,4,1),imshow(Watermark2_1);
subplot(1,4,2),imshow(Watermark2_2);
subplot(1,4,3),imshow(Watermark2_3);
subplot(1,4,4),imshow(Watermark2_4);




