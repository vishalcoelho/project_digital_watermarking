%--------------------------------------------------------------------------
%Function: Bit_plane_generate.m
%Purpose : Returns the bit plane corresponding to the 4x4 host image block 
%          sent by the calling function
%--------------------------------------------------------------------------

function Return_value=Bit_plane_generate(Host_image)

global block_count 
global block_mean block_stddev

[index_x index_y]=size(Host_image);
no_pixels=index_x*index_y;

%% Test Code
% for i=1:index_x
%     for j=1:index_y
%         Return_value(i,j)=Host_image(i,j);
%     end
% end

%% Calculating Mean
intermed_sum=0;
for i=1:index_x
    for j=1:index_y
        intermed_sum=intermed_sum+Host_image(i,j);
    end
end

block_mean(block_count)=intermed_sum/no_pixels;
mean_sqr=(block_mean(block_count)*block_mean(block_count));

%% Calculating second moment
intermed_sum=0;
for i=1:index_x
    for j=1:index_y
        intermed_sum=intermed_sum+(Host_image(i,j)*Host_image(i,j));
    end
end
block_sec_moment=intermed_sum/no_pixels;

%% Calculating Standard Deviation
block_stddev(block_count)=block_sec_moment-mean_sqr;

%% Generate Bit Plane
for i=1:index_x
    for j=1:index_y
        if Host_image(i,j)>block_mean(block_count)
            Return_value(i,j)=1;
        else
            Return_value(i,j)=0;
        end
    end
end

            

%% End of Iteration
block_count=block_count+1;
