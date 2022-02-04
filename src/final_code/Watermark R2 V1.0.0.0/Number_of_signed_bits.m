%--------------------------------------------------------------------------
%Function   :Number_of_signed_bits.m
%statement  :This function counts the number of signed bits in each block
%            of the watermark and returns each block count to a vector 
%--------------------------------------------------------------------------
function [Return_value]=Number_of_signed_bits(Input_matrix)
%count maintains the number of signed bits in each block 
count=0;    
%find size of block
%size=length(Input_matrix);
size=2;
for i=1:size
    for j=1:size
        if Input_matrix(i,j)==0;
            count=count+1;
        end
    end
end
%Return count to the calling function
Return_value=count;
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------