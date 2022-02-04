%--------------------------------------------------------------------------
% Function  : Additive White Gaussian noise
% Objective : This function will add AWGN to the image
%--------------------------------------------------------------------------
function return_value=awgn_attack(input_matrix)
%--------------------------------------------------------------------------
clc;
snr=input('Enter the signal-to-noise ratio: ');
temp_matrix=double(input_matrix);
return_value = uint8(awgn(temp_matrix,snr,'measured'));
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------
