%--------------------------------------------------------------------------
% Funtion      : Polarity_pattern.m
% Statement    : This function generates the polarity pattern for a reduced
%                DCT coefficient matrix
%--------------------------------------------------------------------------
function Return_value=Polarity_pattern(Input_matrix)
%% Binary polarity pattern
%The following code determines the binary polarity pattern as follows
%If the coefficient of current block is greater than the
%previous block, then polarity is 1 else 0

%Assigning polarity for 1st column of 2x2 blocks as 0
for i=1:128
    for j=1:2
%         if abs(Input_matrix(i,j))>abs(Input_matrix(i,126+j))
%             Polarity_pattern_matrix(i,j)=1;
%         else
%             Polarity_pattern_matrix(i,j)=0;
%         end
        Polarity_pattern_matrix(i,j)=0;
    end
end

%Check polarity for odd column elements, assign 1 if current block coeff is
%greater than previous blocks element, else assign 0
for i=1:128
    for j=3:2:127
        if abs(Input_matrix(i,j))>abs(Input_matrix(i,j-2))
            Polarity_pattern_matrix(i,j)=1;
        else
            Polarity_pattern_matrix(i,j)=0;
        end
    end
end
%Check polarity for even column elements, assign 1 if current block coeff is
%greater than previous blocks element, else assign 0
for i=1:128
    for j=4:2:128
        if abs(Input_matrix(i,j))>abs(Input_matrix(i,j-2))
            Polarity_pattern_matrix(i,j)=1;
        else
            Polarity_pattern_matrix(i,j)=0;
        end
    end
end
Return_value=Polarity_pattern_matrix;
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------
