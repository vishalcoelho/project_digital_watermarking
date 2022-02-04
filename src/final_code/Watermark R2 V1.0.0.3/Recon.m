%---------------------------------------------
% Function: Generates the original host block 
%           using the block means and std 
%           deviation        
%---------------------------------------------

function Return_value=Recon(Input_matrix)

global block_count block_mean block_stddev
[index_x index_y]=size(Input_matrix);
q=0;
m=index_x*index_y;
for i=1:index_x
    for j=1:index_y
        if Input_matrix(i,j)==1
            q=q+1;
        end
    end
end
mu=block_mean(block_count);
sig=block_stddev(block_count);

%% a and b
a=mu-(sig*sqrt(q/(m-q)));
b=mu+(sig*sqrt((m-q)/q));
%% Assigning a and b
for i=1:index_x
    for j=1:index_y
        if Input_matrix(i,j)==1
            Return_value(i,j)=b;
        else
            Return_value(i,j)=a;        
        end
    end
end

%% End of Iteration
block_count=block_count+1;
