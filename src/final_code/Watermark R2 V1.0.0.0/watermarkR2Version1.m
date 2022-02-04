%--------------------------------------------------------------------------
%% Program       :Digital Watermarking 
%  Statement     :The following program watermarks a grayscal image of size
%                 512x512 with a 128x128 binary watermark
%  User defined  : Number_of_signed_bits.m
%  functions       Variance_of_block.m 
%                  Mean_middle_coeff.m
%                  Dct_reduce_matrix.m 
%                  Dct_expand_matrix.m
%                  Polarity_pattern.m
%                  Reverse_polarity.m
%--------------------------------------------------------------------------

clc;
clear all;
close all;

%% CONSTANTS
filename1=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\lena.gif'];
filename2=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\watermark.gif'];
filename3=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\Wlena.gif'];
filename4=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\Permute_matrix.bin'];
filename5=['C:\Documents and Settings\savio\My Documents\College\Final Year Project\abvp\Watermark R2 V1.0.0.0\reverse_polarity.bin'];
global Mean_square_value    %required for block computation of variances

%% Function handles
fhandle1=@Number_of_signed_bits;
fhandle2=@Variance_of_block;
fhandle3=@dct2;
fhandle4=@Dct_reduce_matrix;
fhandle5=@Dct_expand_matrix;
fhandle6=@idct2;

%% Read Images
Input_image=imread(filename1);      %Matrix unsigned integer 8
Watermark=imread(filename2);
%Convert the input image to double array for DCT@ processing
Input_image=im2double(Input_image);
%We calculate the number of coefficients that need to be embedded per block
% 64x(M1xM2)/(N1xN2)
% M1,M2 is the size of the watermark
% N1,N2 the size of the input image
% For the following case of M1=M2=128 and N1=N2=512, we have no of
% coefficinets as 4

%% Watermark Permutation 
%Watermark permutation is done to disperse the spatial relationship of the
%binary watermark
for i=1:128
    for j=1:128
        pixel_number_matrix=((i-1)*128)+j;
    end
end
Permute_matrix=randperm(pixel_number_matrix);
file_id=fopen(filename4,'w+');
fwrite(file_id,Permute_matrix,'uint16');
fclose(file_id);
for i=1:128
    for j=1:128
        x_coordinate=int16(Permute_matrix((i-1)*128+j)/128);
        if x_coordinate==0;
            x_coordinate=1;
        end
        y_coordinate=mod(Permute_matrix((i-1)*128+j),128);
        if y_coordinate==0
            y_coordinate=128;
        end
        Watermark_permute(i,j)=Watermark(x_coordinate,y_coordinate);
    end
end
%NOTE: randperm() doesnt have an inverse operation therefore,
%Permute_matrix must be known to the user inorder to generate the watermark
%This is a drawback as it presents a point of attack to an opponent

%% Number of signed bits of the watermark
%Signed_bits_matrix is a 64x64 matrix containing number of signed bits in each 4x4
%block
Signed_bits_matrix=blkproc(Watermark_permute,[2,2],fhandle1);

%% Variance Sorting algorithm
%The code calculates the variance of each 8x8 block of the cover image
%and stores it in matrix Variance_matrix
Mean_square_value=0;

for i=1:512
    for j=1:512
        Mean_square_value=Mean_square_value+Input_image(i,j)*Input_image(i,j);
    end
end
Mean_square_value=Mean_square_value/262144;       %512x512=262144
Variance_matrix=blkproc(Input_image,[8,8],fhandle2);

%% Block permutation of watermark
%This code permutes the 2x2 blocks of the watermark in descending order of
%variances of the corresponding cover image blocks
Block_permute=Watermark_permute;


%% Transformation code
Transform_image=blkproc(Input_image,[8,8],fhandle3);

%% Selecting Middle Coefficients
Dct_coeff_matrix=blkproc(Transform_image,[8,8],fhandle4);

%% Binary polarity pattern
Polarity_pattern_matrix=Polarity_pattern(Dct_coeff_matrix);

%% Embedding the middle coefficients
% After the binary polarity pattern is obtained, for each marked pixel of
% the watermark, modify the DCT coefficients according the residual mask to
% reverse the corresponding polarity.
Reverse_polarity_pattern=xor(Polarity_pattern_matrix,Block_permute);
% imwrite(Reverse_polarity_pattern,filename5,'tiff');

%Find minimum values in each column of the reduced dct matrix, take their
%absolutes and use them to generate a new dct coeff matrix to match the
%reverse polarity matrix

%If the minimum value is greater than 0.1 adding it to a dct coefficient
%will casue visible changes in the cover image 
Minimum_value=abs(min(Dct_coeff_matrix));
matrix_len=length(Minimum_value);
for i=1:matrix_len
    if Minimum_value(i)>0.1
        Minimum_value(i)=Minimum_value(i)/10;
    end
end


for i=1:128
    for j=1:128
        if Reverse_polarity_pattern(i,j)==1
            New_dct_coeff(i,j)=Dct_coeff_matrix(i,j)+Minimum_value(i);
        else
            New_dct_coeff(i,j)=Dct_coeff_matrix(i,j)-Minimum_value(i);
        end
    end
end

% for i=1:128
%     for j=1:2
%         if Reverse_polarity_pattern(i,j)==1
%             New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,126+j))+abs(Dct_coeff_matrix(i,j));
%         else
%             if abs(Dct_coeff_matrix(i,j))>abs(Dct_coeff_matrix(i,126+j));
%                 New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,j))-abs(Dct_coeff_matrix(i,126+j));
%             else
%                 New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,126+j))-abs(Dct_coeff_matrix(i,j));
%             end
%         end
%     end
% end
% 
% %Altering successive coefficients to match the Reverse_polarity_pattern for
% %odd column coefficients
% for i=1:128
%     for j=3:2:127
%         if Reverse_polarity_pattern(i,j)==1
%             New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,j-2))+abs(Dct_coeff_matrix(i,j));
%         else
%             if abs(Dct_coeff_matrix(i,j))>abs(Dct_coeff_matrix(i,j-2))
%                 New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,j))-abs(Dct_coeff_matrix(i,j-2));
%             else
%                 New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,j-2))-abs(Dct_coeff_matrix(i,j));
%             end
%         end
%     end
% end
% %Altering successive coefficients to match the Reverse_polarity_pattern for
% %even column coefficients
% for i=1:128
%     for j=4:2:128
%         if Reverse_polarity_pattern(i,j)==1
%             New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,j-2))+abs(Dct_coeff_matrix(i,j));
%         else
%             if abs(Dct_coeff_matrix(i,j))>abs(Dct_coeff_matrix(i,j-2))
%                 New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,j))-abs(Dct_coeff_matrix(i,j-2));
%             else
%                 New_dct_coeff(i,j)=abs(Dct_coeff_matrix(i,j-2))-abs(Dct_coeff_matrix(i,j));
%             end
%         end
%     end
% end

%Reintroducing these modified coefficients back into a reduced coefficient
%matrix
temp_image1=blkproc(New_dct_coeff,[2,2],fhandle5);
Selection_mask=[1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 0 0 1 1 1 1 1
                0 0 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1];
temp_image2=blkproc(Transform_image,[8,8],'P1.*x',Selection_mask);
Embedded_image=temp_image1+temp_image2;

%% Output image
Output_image=blkproc(Embedded_image,[8,8],fhandle6);
imwrite(Output_image,filename3,'tiff');



%% TEST CODE
close;figure;imshow(Input_image);
close;figure;imshow(Transform_image);
close;figure;imshow(Watermark);


%--------------------------------------------------------------------------
%END OF CODE
%--------------------------------------------------------------------------