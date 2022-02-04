%--------------------------------------------------------------------------
% Function  : Rotation
% Objective : This function will crop the image
%--------------------------------------------------------------------------
function return_value=rotate_attack(input_matrix)
%--------------------------------------------------------------------------
clc;
ang=input('By what angle do you want to rotate the image in the counterclockwise direction: ');
return_value = imrotate(input_matrix,ang,'bilinear','crop');
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------
