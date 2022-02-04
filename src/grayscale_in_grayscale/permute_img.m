%--------------------------------------------------------------------------
% Function  : permute_img.m 
% Objective : Permute the image passed to the function using a pseudo
%             random key
%--------------------------------------------------------------------------
function return_value=permute_img(input_image,arg_key)
%--------------------------------------------------------------------------
%NOTE: Input image passed to function is of format uint8
%--------------------------------------------------------------------------
for i=1:512
    for j=1:512
        key_val=double(arg_key((i-1)*512+j)); %format: double
        x_crd=fix(key_val/512); %format: double
        x_crd=uint32(x_crd);% format: uint32
        %fix rounds the float value to nearest integer towards zero
        y_crd=mod(key_val,512);
        if y_crd==0
            y_crd=512;
        else
            x_crd=x_crd+1;
        end
        return_value(i,j)=input_image(x_crd,y_crd);
    end
end
%--------------------------------------------------------------------------
%End of Function
%--------------------------------------------------------------------------