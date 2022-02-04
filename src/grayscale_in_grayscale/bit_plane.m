%--------------------------------------------------------------------------
% Function  : bit_plane.m 
% Objective : Generate the bit plane of the input image 
%--------------------------------------------------------------------------
function return_value=bit_plane(input_image)
%--------------------------------------------------------------------------
%NOTE: Input image passed to function is of format uint8
%--------------------------------------------------------------------------
global n
for xblk=1:128
    for yblk=1:128
        sum=0; %format: double
        for i=1:n
            for j=1:n
                x_crd=(xblk-1)*n+i;
                y_crd=(yblk-1)*n+j;
                pixel=uint32(input_image(x_crd,y_crd));
                %format: unsigned integer 32 bits
                sum=sum+pixel;%format: unsigned integer 32 bits
            end
        end
        mean=fix(sum/16);%format: uint32
        for i=1:n
            for j=1:n
                x_crd=(xblk-1)*n+i;
                y_crd=(yblk-1)*n+j;
                if input_image(x_crd,y_crd)>mean
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
return_value=logical(temp); %format: logical 1 bit
%--------------------------------------------------------------------------
%End of Function
%--------------------------------------------------------------------------