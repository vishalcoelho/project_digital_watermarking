%--------------------------------------------------------------------------
%Program : Watermarking using dct
%--------------------------------------------------------------------------
clc;
close all;
clear all;
%--------------------------------------------------------------------------
%% Filenames
host_img_file=['C:\Project\Binary DCT\Images\lena.gif'];
wmark_img_file=['C:\Project\Binary DCT\Images\watermark.gif'];
output_img_file=['C:\Project\Binary DCT\Images\output_img.gif'];
prm_key_file=['C:\Project\Binary DCT\Binaries\prm_key.bin'];
signbits_key_file=['C:\Project\Binary DCT\Binaries\signbits_key.bin'];
varmap_key_file=['C:\Project\Binary DCT\Binaries\varmap_key.bin'];
%--------------------------------------------------------------------------
%% Stage 1: Read the images
host_img=imread(host_img_file);
host_img=im2double(host_img);
wmark_img=imread(wmark_img_file);
[sz_x sz_y]=size(wmark_img);
% for i=1:sz_x
%     for j=1:sz_y
%         pix=wmark_img(i,j);
%         if pix==255
%             wmark_img(i,j)=1;
%         elseif pix==40
%             wmark_img(i,j)=0;
%         else
%             ;
%         end
%     end
% end        
wmark_img=logical(wmark_img);
%--------------------------------------------------------------------------
%% Stage 2: Pseudorandom Permutation of the Watermark
prm_key=randperm(sz_x*sz_y);
prm_wmark_img=pix_permute(wmark_img,prm_key);
%--------------------------------------------------------------------------
%% Stage 3: Block based image dependant permutation of the Watermark
[prm_wmark_img prm_key1 prm_key2]=blk_map(prm_wmark_img,host_img);
%--------------------------------------------------------------------------
%% Stage 4:DCT of the Host image
fhandle=@dct2;
blk_sz=8;
dct_host_img=blkproc(host_img,[blk_sz,blk_sz],fhandle);
%--------------------------------------------------------------------------
%% Stage 5: Selecting the middle coefficients
fhandle=@Dct_reduce_matrix;
dct_midcoeff=blkproc(dct_host_img,[blk_sz,blk_sz],fhandle);
%--------------------------------------------------------------------------
%% Stage 6: Binary polarity pattern
polar_matrix=Polarity_pattern(dct_midcoeff);
%--------------------------------------------------------------------------
%% Stage 7: Embedding the middle coefficients
rev_polar_matrix=xor(polar_matrix,prm_wmark_img);
threshold=0.01;
for i=1:128
    for j=1:128
        flag=rev_polar_matrix(i,j);
        val=dct_midcoeff(i,j);
        if flag==0
            dct_newcoeff(i,j)=val+threshold;
        else
            dct_newcoeff(i,j)=val-threshold;
        end
    end
end
%--------------------------------------------------------------------------
%% Stage 8: Renserting the coeffs into host
fhandle=@Dct_expand_matrix;
tmp_img1=blkproc(dct_newcoeff,[2,2],fhandle);
Selection_mask=[1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 0 0 1 1 1 1 1
                0 0 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1
                1 1 1 1 1 1 1 1];
tmp_img2=blkproc(dct_host_img,[blk_sz,blk_sz],'P1.*x',Selection_mask);
embed_img=tmp_img1+tmp_img2;
%--------------------------------------------------------------------------
%% Stage 9: Output image
fhandle=@idct2;
output_img=blkproc(embed_img,[blk_sz,blk_sz],fhandle);
output_img=im2uint8(output_img);
%--------------------------------------------------------------------------
%% Stage n-1: Writing data to file
fid=fopen(prm_key_file,'w+');
fwrite(fid,prm_key,'uint32');
fclose(fid);

fid=fopen(signbits_key_file,'w+');
fwrite(fid,prm_key1,'uint32');
fclose(fid);

fid=fopen(varmap_key_file,'w+');
fwrite(fid,prm_key2,'uint32');
fclose(fid);

% Output image
imwrite(output_img,output_img_file,'tiff');
%--------------------------------------------------------------------------
%% Stage n: Display
figure,imshow(host_img);
figure,imshow(wmark_img);
figure,imshow(prm_wmark_img);
figure,imshow(dct_host_img);
figure,imshow(output_img);
%--------------------------------------------------------------------------
% End of Code
%--------------------------------------------------------------------------