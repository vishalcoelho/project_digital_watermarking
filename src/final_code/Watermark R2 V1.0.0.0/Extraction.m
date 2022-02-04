%--------------------------------------------------------------------------
%% Program       : Extraction of Watermark 
%  Statement     : The following function extracts the watermark from the
%                  originally embedded image
%  User defined  : Dct_reduce_matrix.m
%  functions       Polarity_pattern.m
%                  
%                  
%                  
%--------------------------------------------------------------------------

clc;
clear all;
close all;

%% Constants
filename1=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\lena.gif'];
filename2=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\Wlena.gif'];
filename3=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\Permute_matrix.bin'];
filename4=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\reverse_polarity.bin'];
filename5=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\ExtractedWmark.gif'];
filename6=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\RWlena.gif'];
filename7=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\CWlena.gif'];
filename8=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\CWlena1.gif'];
filename9=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\Wlena.jpg'];
filename10=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\SWlena.gif'];


%% Function Handles
fhandle1=@dct2;
fhandle2=@Dct_reduce_matrix;

%% Image read
% Read original and watermarked images
Original_image=imread(filename1);
Original_image=im2double(Original_image);
% Watermarked_image=imread(filename2);
% Watermarked_image=im2double(Watermarked_image);

%% Attacks
%1. Rotation: Here we have rotated the watermarked version of Lena and are
%attempting to see how well the watermark stands up to this kind of attack
%NOTE:Here the rotated watermarked image i.e. filename6 is read
Watermarked_image1=imread(filename6);
Watermarked_image1=im2double(Watermarked_image1);

%2.Cropping: Here a portion of the watermarked image is cropped
%NOTE: Here the cropped image is read i.e. filename7 or filename8
%Watermarked_image=imread(filename7);
Watermarked_image2=imread(filename8);
Watermarked_image2=im2double(Watermarked_image2);

%3.JPEG Conversion: Image is converted from .gif to .jpg format using a
%file conversion program called IrfanView, here filename9 corresponds to
%the converted image
Watermarked_image3=imread(filename9);
Watermarked_image3=im2double(Watermarked_image3);

%4.Scaling: here the watermarked image is scaled by 1%
Watermarked_image4=imread(filename10);
Watermarked_image4=im2double(Watermarked_image4);

%% Block Transformation
% Taking DCT of both the orignal and Watermarked images
Transform_original_image=blkproc(Original_image,[8,8],fhandle1);
Transform_watermarked_image1=blkproc(Watermarked_image1,[8,8],fhandle1);
Transform_watermarked_image2=blkproc(Watermarked_image2,[8,8],fhandle1);
Transform_watermarked_image3=blkproc(Watermarked_image3,[8,8],fhandle1);
Transform_watermarked_image4=blkproc(Watermarked_image4,[8,8],fhandle1);

%% DCT block reduction
% Taking 4 dcts coeffs from each 8x8 block of both the original and
% watermarked images and generating their respective reduced dct matrices
Reduced_dct_original=blkproc(Transform_original_image,[8,8],fhandle2);
Reduced_dct_watermarked1=blkproc(Transform_watermarked_image1,[8,8],fhandle2);
Reduced_dct_watermarked2=blkproc(Transform_watermarked_image2,[8,8],fhandle2);
Reduced_dct_watermarked3=blkproc(Transform_watermarked_image3,[8,8],fhandle2);
Reduced_dct_watermarked4=blkproc(Transform_watermarked_image4,[8,8],fhandle2);

%% Binary Polarity Pattern
% Find polarity pattern of reduced dct matrices
Polarity_pattern_original=Polarity_pattern(Reduced_dct_original);
% Polarity_pattern_watermarked=imread(filename4);
for i=1:128
    for j=1:128
        if Reduced_dct_watermarked1(i,j)<Reduced_dct_original(i,j)
            Polarity_pattern_watermarked1(i,j)=0;
        else
            Polarity_pattern_watermarked1(i,j)=1;
        end
    end
end
for i=1:128
    for j=1:128
        if Reduced_dct_watermarked2(i,j)<Reduced_dct_original(i,j)
            Polarity_pattern_watermarked2(i,j)=0;
        else
            Polarity_pattern_watermarked2(i,j)=1;
        end
    end
end
for i=1:128
    for j=1:128
        if Reduced_dct_watermarked3(i,j)<Reduced_dct_original(i,j)
            Polarity_pattern_watermarked3(i,j)=0;
        else
            Polarity_pattern_watermarked3(i,j)=1;
        end
    end
end
for i=1:128
    for j=1:128
        if Reduced_dct_watermarked4(i,j)<Reduced_dct_original(i,j)
            Polarity_pattern_watermarked4(i,j)=0;
        else
            Polarity_pattern_watermarked4(i,j)=1;
        end
    end
end

% %Generate reverse polarity map
% for i=1:128
%     for j=1:2
%         if abs(Reduced_dct_watermarked(i,j))<abs(Reduced_dct_watermarked(i,126+j))
%             Polarity_pattern_watermarked(i,j)=0;
%         else
%             Polarity_pattern_watermarked(i,j)=1;
%         end
%     end
% end
% 
% %Altering successive coefficients to match the Reverse_polarity_pattern for
% %odd column coefficients
% for i=1:128
%     for j=3:2:127
%         if abs(Reduced_dct_watermarked(i,j))<abs(Reduced_dct_watermarked(i,j-2))
%             Polarity_pattern_watermarked(i,j)=0;
%         else
%             Polarity_pattern_watermarked(i,j)=1;
%         end
%     end
% end
% %Altering successive coefficients to match the Reverse_polarity_pattern for
% %even column coefficients
% for i=1:128
%     for j=4:2:128
%         if abs(Reduced_dct_watermarked(i,j))<abs(Reduced_dct_watermarked(i,j-2))
%             Polarity_pattern_watermarked(i,j)=0;
%         else
%             Polarity_pattern_watermarked(i,j)=1;
%         end
%     end
% end

%% Extraction of permuted data
% Extract the block permuted watermark
Block_permute1=xor(Polarity_pattern_original,Polarity_pattern_watermarked1);
Block_permute2=xor(Polarity_pattern_original,Polarity_pattern_watermarked2);
Block_permute3=xor(Polarity_pattern_original,Polarity_pattern_watermarked3);
Block_permute4=xor(Polarity_pattern_original,Polarity_pattern_watermarked4);

%% Reverse Block-based Image-Dependent Permutation
% Get the spatially dispersed watermark
Watermark_Permute1=Block_permute1;
Watermark_Permute2=Block_permute2;
Watermark_Permute3=Block_permute3;
Watermark_Permute4=Block_permute4;

%% Reverse Spatial permutation
% This permutation map was used to spatially disperse the watermark during
% the watermarking process

% TEST CODE
% Watermark_Permute=imread('C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\Watermark_permute.gif');
% figure,imshow(Watermark_Permute);

file_id=fopen(filename3,'r');
Permute_matrix=fread(file_id,'uint16');
fclose(file_id);

for i=1:128
    for j=1:128
        x_coordinate=int16(Permute_matrix((i-1)*128+j)/128);
        if x_coordinate==0
            x_coordinate=1;
        end
        y_coordinate=mod(Permute_matrix((i-1)*128+j),128);
        if y_coordinate==0
            y_coordinate=128;
        end
        Watermark1(x_coordinate,y_coordinate)=Watermark_Permute1(i,j);
    end
end
for i=1:128
    for j=1:128
        x_coordinate=int16(Permute_matrix((i-1)*128+j)/128);
        if x_coordinate==0
            x_coordinate=1;
        end
        y_coordinate=mod(Permute_matrix((i-1)*128+j),128);
        if y_coordinate==0
            y_coordinate=128;
        end
        Watermark2(x_coordinate,y_coordinate)=Watermark_Permute2(i,j);
    end
end
for i=1:128
    for j=1:128
        x_coordinate=int16(Permute_matrix((i-1)*128+j)/128);
        if x_coordinate==0
            x_coordinate=1;
        end
        y_coordinate=mod(Permute_matrix((i-1)*128+j),128);
        if y_coordinate==0
            y_coordinate=128;
        end
        Watermark3(x_coordinate,y_coordinate)=Watermark_Permute3(i,j);
    end
end
for i=1:128
    for j=1:128
        x_coordinate=int16(Permute_matrix((i-1)*128+j)/128);
        if x_coordinate==0
            x_coordinate=1;
        end
        y_coordinate=mod(Permute_matrix((i-1)*128+j),128);
        if y_coordinate==0
            y_coordinate=128;
        end
        Watermark4(x_coordinate,y_coordinate)=Watermark_Permute4(i,j);
    end
end

%% Display
%1. Cropping
close;figure;imshow(Original_image);
close;figure;imshow(Watermarked_image2);
%2. JPEG
close;figure;imshow(Watermark2);
close;figure;imshow(Watermarked_image3);
%3. Rotation
close;figure;imshow(Watermark3);
close;figure;imshow(Watermarked_image1);
%4. Scaling
close;figure;imshow(Watermark1);
close;figure;imshow(Watermarked_image4);
close;figure;imshow(Watermark4);
imwrite(Watermark1,filename5,'tiff');



%--------------------------------------------------------------------------
%END OF CODE
%--------------------------------------------------------------------------