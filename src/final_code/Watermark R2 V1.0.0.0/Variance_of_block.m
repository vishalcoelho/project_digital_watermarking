%--------------------------------------------------------------------------
%Function   :Variance_of_block.m
%statement  :This function returns the variance of each 8x8 block of the
%            cover image
%--------------------------------------------------------------------------
function [Return_value]=Variance_of_block(Input_matrix)
global Mean_square_value;
Block_square_value=0;       %stores the variance of 8x8 block 
for i=1:8
    for j=1:8
        Block_square_value=Block_square_value+Input_matrix(i,j)*Input_matrix(i,j);
    end
end
Block_square_value=Block_square_value/64;    %8x8=64
Return_value=abs(Mean_square_value-Block_square_value);
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------