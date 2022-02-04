clc;
clear all;
close all;
num=221184;
for i=1:510
    val=mod(num,i);
    if val==0
        disp(i);
    end
end

