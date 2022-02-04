%--------------------------------------------------------------------------
% Function   : bit_plane.m 
% Purpose    : Generate the bit plane of the input image 
%--------------------------------------------------------------------------
function ret_matrix=bit_plane(arg_matrix,arg_blk_sz)
%--------------------------------------------------------------------------
%NOTE: Input image passed to function is of format uint8
%--------------------------------------------------------------------------
[size_x size_y]=size(arg_matrix);
for xblk=1:(size_x/arg_blk_sz)
    for yblk=1:(size_y/arg_blk_sz)
        sum=0; %format: double
        for i=1:arg_blk_sz
            for j=1:arg_blk_sz
                x_crd=(xblk-1)*arg_blk_sz+i;
                y_crd=(yblk-1)*arg_blk_sz+j;
                pixel=uint32(arg_matrix(x_crd,y_crd));
                %format: unsigned integer 32 bits
                sum=sum+pixel;%format: unsigned integer 32 bits
            end
        end
        mean=fix(sum/(arg_blk_sz*arg_blk_sz));%format: uint32
        for i=1:arg_blk_sz
            for j=1:arg_blk_sz
                x_crd=(xblk-1)*arg_blk_sz+i;
                y_crd=(yblk-1)*arg_blk_sz+j;
                if arg_matrix(x_crd,y_crd)>mean
                    temp(x_crd,y_crd)=1;
                    %format: double
                else
                    temp(x_crd,y_crd)=0;
                    %format: double
                end
            end
        end
    end
end
ret_matrix=logical(temp); %format: logical 1 bit
%--------------------------------------------------------------------------
%End of Function
%--------------------------------------------------------------------------