%--------------------------------------------------------------------------
% Function  : Cropping.m
% Objective : This function will crop the image
%--------------------------------------------------------------------------
function return_value=crop_attack(input_matrix)
%--------------------------------------------------------------------------
clc;
p=input('Enter the percentage of the image you want cropped :');
[size_x size_y]=size(input_matrix);
x_crd=floor(size_x*(p/100));
y_crd=floor(size_y*(p/100));
return_value=input_matrix;
for i=1:x_crd
    for j=1:y_crd
        return_value(i,j)=255;
    end
end
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------
        