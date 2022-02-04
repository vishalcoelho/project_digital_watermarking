%--------------------------------------------------------------------------
% Function : blk_map.m
%--------------------------------------------------------------------------
function [ret_matrix ret_key1 ret_key2]=blk_map(arg_wmark,arg_host)
%--------------------------------------------------------------------------
%% Stage 1: Calculate no of signed bits in watermark
[sz_x sz_y]=size(arg_wmark);
blk_sz=2;
blksz_x=sz_x/blk_sz;
blksz_y=sz_y/blk_sz;
for i=1:blksz_x
    for j=1:blksz_y
        ind=(i-1)*blksz_x+j;
        sum=0;
        for k=1:blk_sz
            for l=1:blk_sz
                ind_x=(i-1)*blk_sz+k;
                ind_y=(j-1)*blk_sz+l;
                pix=arg_wmark(ind_x,ind_y);
                if pix==0
                    sum=sum+1;
                end
            end
        end
        sign_bits(ind,1)=sum;
        sign_bits(ind,2)=ind;
    end
end
%--------------------------------------------------------------------------
%% Stage 2: Variance of the host image
[sz_x sz_y]=size(arg_host);
blk_sz=8;
blksz_x=sz_x/blk_sz;
blksz_y=sz_y/blk_sz;
for i=1:blksz_x
    for j=1:blksz_y
        ind=(i-1)*blksz_x+j;
        sum=0;
        sqr_sum=0;
        for k=1:blk_sz
            for l=1:blk_sz
                ind_x=(i-1)*blk_sz+k;
                ind_y=(j-1)*blk_sz+l;
                pix=double(arg_host(ind_x,ind_y));
                sum=sum+pix;
                sqr_sum=sqr_sum+(pix*pix);
            end
        end
        mean=sum/(blk_sz*blk_sz);
        sqr_mean=sqr_sum/(blk_sz*blk_sz);
        var=sqr_mean-(mean*mean);
        host_var(ind,1)=var;
        host_var(ind,2)=ind;
    end
end
%--------------------------------------------------------------------------
%% Stage 3: Sort both matrices
sort_sign_bits=bsort(sign_bits);
sort_host_var=bsort(host_var);
%--------------------------------------------------------------------------
%% Stage 4: Permute the watermark as per number of sign bits
prm_key=sort_sign_bits(:,2);
arg_wmark=blk_permute(arg_wmark,prm_key);
ret_key1=prm_key;
%--------------------------------------------------------------------------
%% Stage 5: Variance map permutation
prm_key=sort_host_var(:,2);
ret_matrix=blk_permute(arg_wmark,prm_key);
ret_key2=prm_key;
%--------------------------------------------------------------------------
% End of Function
%--------------------------------------------------------------------------