%--------------------------------------------------------------------------
% Function : bps.m
%--------------------------------------------------------------------------
function ret_matrix=ibps(arg_matrix)
%--------------------------------------------------------------------------
%% Stage 1: Unpad by cropping
for i=1:432
    for j=1:512
        tmp_matrix(i,j)=arg_matrix(i,j);
    end
end
%--------------------------------------------------------------------------
%% Stage 2: Retrieving the bit representations
blk_x=3;
blk_y=8;
count=1;    % count goes from 1 to 9216
x_crd=1;    % x_crd goes from 1 to 432
y_crd=1;    % y_crd goes from 1 to 512
for i=1:144  %144 is 432/3
    for j=1:64    %64 is 512/8
        for k=1:blk_x
            for l=1:blk_y
                x_crd=(i-1)*blk_x+k;
                y_crd=(j-1)*blk_y+l;
                pos=(k-1)*blk_y+l;
                bit=tmp_matrix(x_crd,y_crd);
                rgb_pix(count,pos)=bit;
            end
        end
        count=count+1;
    end
end
%--------------------------------------------------------------------------
%% Stage 3: Obtaining the R,G and B binary representations
sz_x=96;
sz_y=96;
sz_z=3;
sz=sz_x*sz_y;
for i=1:sz_x
    for j=1:sz_y
        for k=1:blk_x
            for l=1:blk_y
                ind_x=(i-1)*sz_x+j;
                ind_y=(k-1)*8+l;
                switch k
                    case 1
                        r_pix(l)=rgb_pix(ind_x,ind_y);
                    case 2
                        g_pix(l)=rgb_pix(ind_x,ind_y);
                    otherwise
                        b_pix(l)=rgb_pix(ind_x,ind_y);
                end
            end
        end
        r_bit=mat2dec(r_pix);
        g_bit=mat2dec(g_pix);
        b_bit=mat2dec(b_pix);
        R(i,j)=uint8(r_bit);
        G(i,j)=uint8(g_bit);
        B(i,j)=uint8(b_bit);
    end
end
%--------------------------------------------------------------------------
%% Stage 1: Combine the R,G and B representations
for i=1:sz_z
    for j=1:sz_x
        for k=1:sz_y
            switch i
                case 1
                    ret_matrix(j,k,i)=R(j,k);
                case 2
                    ret_matrix(j,k,i)=G(j,k);
                case 3
                    ret_matrix(j,k,i)=B(j,k);
            end
        end
    end
end
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------
