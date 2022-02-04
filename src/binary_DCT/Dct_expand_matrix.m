%--------------------------------------------------------------------------
%Function   :Dct_expand_matrix.m
%statement  :This function reincorporates the modified DCT values back into
%            the transformed image
%--------------------------------------------------------------------------
function [Return_value]=Dct_expand_matrix(Input_matrix)
temp=zeros(8,8);
temp(4,2)=Input_matrix(1,1);
temp(4,3)=Input_matrix(1,2);
temp(5,1)=Input_matrix(2,1);
temp(5,2)=Input_matrix(2,2);
Return_value=temp;
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------