%--------------------------------------------------------------------------
% Function  : impermute.m
%--------------------------------------------------------------------------
function ret_matrix=impermute(arg_matrix,arg_key,arg_sel)
%--------------------------------------------------------------------------
%% Permutation
[sz_x sz_y]=size(arg_matrix);
switch arg_sel
    case 1
        for i=1:sz_x
            for j=1:sz_y
                ind=(i-1)*sz_x+j;
                x_crd=floor(arg_key(ind)/sz_x);
                y_crd=mod(arg_key(ind),sz_y);
                x_crd=x_crd+1;
                if y_crd==0
                    y_crd=sz_y;
                    x_crd=x_crd-1;
                end
                ret_matrix(x_crd,y_crd)=arg_matrix(i,j);
            end
        end
    case 2
        [dx dy]=size(arg_key);
        sz_blk_x=sqrt(dy);
        sz_blk_y=sz_blk_x;
        sz_blk=sz_x/sz_blk_x;
        for i=1:sz_blk_x
            for j=1:sz_blk_y
                ind=(i-1)*sz_blk_x+j;
                block=arg_key(ind);
                rank=floor(block/sz_blk_x);
                file=mod(block,sz_blk_y);
                %rank and file are the variables indicating which column or
                %row the blocks lie in.....used in chess
                rank=rank+1;
                if file==0
                    file=sz_blk_y;
                    rank=rank-1;
                end
                x_blk=(rank-1)*sz_blk+1;
                y_blk=(file-1)*sz_blk+1;
                %x_blk and y_blk are the top left coordinates of each block
                for k=1:sz_blk
                    for l=1:sz_blk
                        x_src=(x_blk-1)+k;
                        y_src=(y_blk-1)+l;
                        x_dst=(i-1)*sz_blk+k;
                        y_dst=(j-1)*sz_blk+l;
                        ret_matrix(x_dst,y_dst)=arg_matrix(x_src,y_src);
                    end
                end
            end
        end
    otherwise
        disp('Hello');
end
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------