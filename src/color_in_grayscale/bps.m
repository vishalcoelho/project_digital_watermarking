%--------------------------------------------------------------------------
% Function : bps.m
%--------------------------------------------------------------------------
function ret_matrix=bps(arg_matrix)
%--------------------------------------------------------------------------
%NOTE : This function is written solely for a matrix 96x96x3
%--------------------------------------------------------------------------
%% Stage 1: seperate the R,G and B components into seperate matrices
[sz_x sz_y sz_z]=size(arg_matrix);
for i=1:sz_z
    for j=1:sz_x
        for k=1:sz_y
            switch i
                case 1
                    R(j,k)=arg_matrix(j,k,i);
                case 2
                    G(j,k)=arg_matrix(j,k,i);
                otherwise
                    B(j,k)=arg_matrix(j,k,i);
            end
        end
    end
end
%--------------------------------------------------------------------------
%% Stage 2: Obtaining the binary representations
for i=1:sz_x
    for j=1:sz_y
        r_bit=R(i,j);
        g_bit=G(i,j);
        b_bit=B(i,j);
        r_pix=dec2mat(r_bit);
        g_pix=dec2mat(g_bit);
        b_pix=dec2mat(b_bit);
        for k=1:3
            for l=1:8
                ind_x=(i-1)*sz_x+j;
                ind_y=(k-1)*8+l;
                switch k
                    case 1
                        rgb_pix(ind_x,ind_y)=r_pix(l);
                    case 2
                        rgb_pix(ind_x,ind_y)=g_pix(l);
                    otherwise
                        rgb_pix(ind_x,ind_y)=b_pix(l);
                end
            end
        end
    end
end
%--------------------------------------------------------------------------
%% Stage 3: Creating the bit plane
sz=sz_x*sz_y;
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
                bit=rgb_pix(count,pos);
                ret_matrix(x_crd,y_crd)=logical(bit);
            end
        end
        count=count+1;
    end
end
%--------------------------------------------------------------------------
%% Stage 4: Padding
for i=433:512
    for j=1:512
        ret_matrix(i,j)=ret_matrix(432,j);
    end
end
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------
