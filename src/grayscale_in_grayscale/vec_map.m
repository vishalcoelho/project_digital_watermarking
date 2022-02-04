%--------------------------------------------------------------------------
% Function  : vec_map.m 
% Objective : Generate the vector map that maps the watermark blocks to
%             host image blocks of similar means
%--------------------------------------------------------------------------
function return_value=vec_map(w_arg,h_arg)
%--------------------------------------------------------------------------
%NOTE: The arguments to this function are the means of format uint32
%--------------------------------------------------------------------------
for i=1:16384
    m1=double(w_arg(i));   %format: double
    m2=double(h_arg(1));   %format: double
    temp=abs(m1-m2); %format: double
    index=1; %format: double
    for j=2:16384
        m3=double(h_arg(j));
        diff=abs(m1-m3);
        %format: double
        if diff<temp
            temp=diff;
            index=j;
        end
    end
    return_value(i)=uint32(index);
    %format: Unsigned integer 32 bits
end
%--------------------------------------------------------------------------
%End of Function
%--------------------------------------------------------------------------