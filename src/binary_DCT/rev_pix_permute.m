%--------------------------------------------------------------------------
% Function : rev_pix_permute.m
%--------------------------------------------------------------------------
function ret_matrix=rev_pix_permute(arg_matrix,arg_key)
%--------------------------------------------------------------------------
[sz_x sz_y]=size(arg_matrix);
for i=1:sz_x
    for j=1:sz_y
        ind=(i-1)*sz_x+j;
        key_val=arg_key(ind);
        xcd=floor(key_val/sz_x)+1;
        ycd=mod(key_val,sz_y);
        if ycd==0
            ycd=sz_y;
            xcd=xcd-1;
        end
        ret_matrix(i,j)=arg_matrix(xcd,ycd);
    end
end
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------