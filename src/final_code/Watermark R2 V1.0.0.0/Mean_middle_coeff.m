%--------------------------------------------------------------------------
%Function   :Mean_middle_coeff.m
%statement  :This function returns the mean of the masked middle
%            coefficients matrix. This is done so as to calculate binary polarity
%            pattern
%--------------------------------------------------------------------------
function [Return_value]=Mean_middle_coeff(Input_matrix)
Mean=0;
for i=1:2
    for j=1:2
        Mean=Mean+Input_matrix(i,j);
    end
end
Return_value=Mean/4; %since only 4 coeffs are present in the masked 
                     %coefficient matrix
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------