%--------------------------------------------------------------------------
%Function   :Dct_reduce_matrix.m
%statement  :This function returns a reduced matrix that conatins all the 
%            middle coefficients
%--------------------------------------------------------------------------
function [Return_value]=Dct_reduce_matrix(Input_matrix)
temp_value(1,1)=Input_matrix(4,2);
temp_value(1,2)=Input_matrix(4,3);
temp_value(2,1)=Input_matrix(5,1);
temp_value(2,2)=Input_matrix(5,2);
Return_value=temp_value;
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------