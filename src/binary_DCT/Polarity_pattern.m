%--------------------------------------------------------------------------
% Funtion      : Polarity_pattern.m
% Statement    : This function generates the polarity pattern for a reduced
%                DCT coefficient matrix
%--------------------------------------------------------------------------
function ret_matrix=Polarity_pattern(arg_matrix)
%--------------------------------------------------------------------------
%% Binary polarity pattern
polar_matrix(1:128,1:2)=1;
for i=1:128
    for j=3:128
        curr=arg_matrix(i,j);
        prev=arg_matrix(i,j-2);
        if curr>0 && prev>0
            if curr>prev
                op=0;
            else
                op=1;
            end
        elseif curr>0 && prev<0
            op=0;
        elseif curr<0 && prev>0
            op=1;
        else
            if abs(prev)>abs(curr)
                op=0;
            else
                op=1;
            end
        end
        polar_matrix(i,j)=op;
    end
end
ret_matrix=logical(polar_matrix);
%--------------------------------------------------------------------------
%END OF FUNCTION
%--------------------------------------------------------------------------
