%--------------------------------------------------------------------------
% Function  : recover.m 
% Objective : Generates the grayscale image, arguments to the function are
%             the bit plane of the watermark,its block means and standard 
%             deviations
%--------------------------------------------------------------------------
function return_value=recover(input_image,img_mean,img_stdev)
%--------------------------------------------------------------------------
%NOTE: Input image passed to function is of format logical and mean and
%standard deviation of format uint32
%--------------------------------------------------------------------------
global n
m=16; %format: double
for xblk=1:128
    for yblk=1:128
        q=0; %format: double
        index=((xblk-1)*128)+yblk;
        for i=1:n
            for j=1:n
                x_crd=(xblk-1)*n+i;
                y_crd=(yblk-1)*n+j;
                if input_image(x_crd,y_crd)==1
                    q=q+1;
                end
            end
        end
        mu=img_mean(index); %format: Unsigned integer 32 bits
        sig=img_stdev(index); %format: Unsigned integer 32 bits
        zeros=(m-q);
        ones=q;
        arg_u=ones/zeros; %format: double
        arg_v=zeros/ones; %format: double
        u=sqrt(arg_u); %format: double
        v=sqrt(arg_v); %format: double   
        a=fix(mu-(sig*u)); %format: Unsigned integer 32 bits
        a=uint8(a); %format: Unsigned integer 32 bits
        b=fix(mu+(sig*v)); %format: Unsigned integer 8 bits
        b=uint8(b); %format: Unsigned integer 8 bits
        for i=1:n
            for j=1:n
                x_crd=(xblk-1)*n+i;
                y_crd=(yblk-1)*n+j;
                if input_image(x_crd,y_crd)==1
                    return_value(x_crd,y_crd)=b;
                    %format: Unsigned integer 8 bits
                else
                    return_value(x_crd,y_crd)=a;
                    %format: Unsigned integer 8 bits
                end
            end
        end
    end
end
%--------------------------------------------------------------------------
%End of Function
%--------------------------------------------------------------------------
        