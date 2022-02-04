%--------------------------------------------------------------------------
% Program: Normalised correlation of two images
%--------------------------------------------------------------------------
clc;
close all;
clear all;
%--------------------------------------------------------------------------
%% Filenames
image_file_1=['C:\Project\Binary DCT\Images\logo.gif'];
image_file_2=['C:\Project\Binary DCT\Images\ext_wmark.gif'];
%--------------------------------------------------------------------------
img_1=imread(image_file_1);
img_2=imread(image_file_2);
[sz_x sz_y]=size(img_1);
for i=1:sz_x
    for j=1:sz_y
        pix=img_1(i,j);
        if pix==255
            op=1;
        elseif pix==40
            op=0;
        else
            ;
        end
        img_1(i,j)=op;
    end
end
img_1=logical(img_1);
sum=0;
prod=0;
for i=1:sz_x
    for j=1:sz_y
        prod=prod+(img_1(i,j)*img_2(i,j));
        sum=sum+(img_1(i,j)*img_1(i,j));
    end
end
nc=prod/sum;
figure;
subplot(1,2,1),imshow(img_1);
subplot(1,2,2),imshow(img_2);
fprintf('The Normalized Correlation is: %0.4f\n',nc);
%--------------------------------------------------------------------------
% End of Code
%--------------------------------------------------------------------------
