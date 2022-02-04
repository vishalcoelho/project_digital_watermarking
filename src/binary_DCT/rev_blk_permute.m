%--------------------------------------------------------------------------
% Function : blk_permute.m
%--------------------------------------------------------------------------
function ret_matrix=blk_permute(arg_matrix,arg_key)
%--------------------------------------------------------------------------
[dx dy]=size(arg_key);
if dx>dy
    arg_key=arg_key';
    [dx dy]=size(arg_key);
end
[sz_x sz_y]=size(arg_matrix);
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
                x_dst=(x_blk-1)+k;
                y_dst=(y_blk-1)+l;
                x_src=(i-1)*sz_blk+k;
                y_src=(j-1)*sz_blk+l;
                ret_matrix(x_dst,y_dst)=arg_matrix(x_src,y_src);
            end
        end
    end
end

%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------