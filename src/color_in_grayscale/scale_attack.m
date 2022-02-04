%--------------------------------------------------------------------------
% Function  : Scaling
% Objective : This function will scale the image
%--------------------------------------------------------------------------
function return_value=scale_attack(input_matrix)
%--------------------------------------------------------------------------
clc;
size=input('Enter the percentage resize you require: ');
return_value = imresize(input_matrix,size,'bilinear');
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------
