%--------------------------------------------------------------------------
%Function   :Dct_reduce_matrix.m
%statement  :This function returns a reduced matrix that conatins all the 
%            middle coefficients
%--------------------------------------------------------------------------
function ret_val=Dct_reduce_matrix(arg_matrix)
%--------------------------------------------------------------------------
temp_value(1,1)=arg_matrix(4,2);
temp_value(1,2)=arg_matrix(4,3);
temp_value(2,1)=arg_matrix(5,1);
temp_value(2,2)=arg_matrix(5,2);
ret_val=temp_value;
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------