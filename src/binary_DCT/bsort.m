%--------------------------------------------------------------------------
% Function : bsort.m
%--------------------------------------------------------------------------
function ret_matrix=bsort(arg_matrix)
%--------------------------------------------------------------------------
[sz_x sz_y]=size(arg_matrix);
if sz_y>sz_x
    tmp_matrix=arg_matrix';
else
    tmp_matrix=arg_matrix;
end
for i=1:(sz_x-1)
    j=1;
    k=2;
    while((j~=sz_x-1)&&(k~=sz_x))
        first=tmp_matrix(j,1);
        fpos=tmp_matrix(j,2);
        second=tmp_matrix(k,1);
        spos=tmp_matrix(k,2);
        if first<second
            tmp_matrix(j,1)=second;
            tmp_matrix(j,2)=spos;
            tmp_matrix(k,1)=first;
            tmp_matrix(k,2)=fpos;
        end
        j=j+1;
        k=k+1;
    end
end
ret_matrix=tmp_matrix;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------