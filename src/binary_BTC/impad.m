%--------------------------------------------------------------------------
% Function : impad.m
%--------------------------------------------------------------------------
function ret_matrix=impad(arg_matrix,arg_szx,arg_szy)
%--------------------------------------------------------------------------
[sz_x sz_y]=size(arg_matrix);
ret_matrix=arg_matrix;
if ((sz_x~=arg_szx)&&(sz_y~=arg_szy))
    for i=(sz_x+1):arg_szx
        for j=1:sz_y
            ret_matrix(i,j)=arg_matrix(sz_x,j);
        end
    end
    for i=1:arg_szx
        for j=(sz_y+1):arg_szy
            ret_matrix(i,j)=ret_matrix(i,sz_y);
        end
    end
end
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------