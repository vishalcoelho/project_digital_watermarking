%--------------------------------------------------------------------------
% Function  : b_stdev.m 
% Objective : Calculate the standard deviation of each 4x4 block of the 
%             input image 
%--------------------------------------------------------------------------
function return_value=b_mean(input_image)
%--------------------------------------------------------------------------
%NOTE: Input image passed to function is of format uint8
%--------------------------------------------------------------------------
global n
for xblk=1:128
    for yblk=1:128
        sum=0;  %format: double
        sqr_sum=0;  %format: double
        for i=1:n
            for j=1:n
                x_crd=(xblk-1)*n+i;
                y_crd=(yblk-1)*n+j;
                pixel=double(input_image(x_crd,y_crd));
                %format: double
                sum=sum+pixel;
                %format: double
                sqr_sum=sqr_sum+(pixel*pixel);
                %format: double
            end
        end
        mean=sum/16;    %format: double
        sqr_mean=sqr_sum/16;    %format: double
        stdev=fix(sqrt(sqr_mean-(mean*mean))); %format: double
        stdev=uint32(stdev);    %format: Unsigned integer 32 bits
        index=(xblk-1)*128+yblk;
        return_value(index)=stdev;
        %format: Unsigned integer 32 bits
    end
end
%--------------------------------------------------------------------------
%End of Function
%--------------------------------------------------------------------------