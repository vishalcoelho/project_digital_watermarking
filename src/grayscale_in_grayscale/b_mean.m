%--------------------------------------------------------------------------
% Function  : b_mean.m 
% Objective : Calculate the mean of each 4x4 block of the input image 
%--------------------------------------------------------------------------
function return_value=b_mean(input_image)
%--------------------------------------------------------------------------
%NOTE: Input image passed to function is of format uint8
%--------------------------------------------------------------------------
global n
for xblk=1:128
    for yblk=1:128
        sum=0;  %format: double
        for i=1:n
            for j=1:n
                x_crd=(xblk-1)*n+i;
                y_crd=(yblk-1)*n+j;
                pixel=double(input_image(x_crd,y_crd));
                %format: double
                sum=sum+pixel;
                %format: double
            end
        end
        mean=uint32(fix(sum/16));
        %format: Unsigned integer 32 bits
        index=(xblk-1)*128+yblk;
        return_value(index)=mean;
        %format: Unsigned integer 32 bits
    end
end
%--------------------------------------------------------------------------
%End of Function
%--------------------------------------------------------------------------