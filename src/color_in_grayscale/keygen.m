%--------------------------------------------------------------------------
% Function  : keygen.m
%--------------------------------------------------------------------------
function [ret_key ret_sel]=keygen(arg_matrix)
%--------------------------------------------------------------------------
%% Menu
clc;
fprintf('1. Pixel permutation\n2. Block permutation\n');
choice=input('Enter your choice :');
%--------------------------------------------------------------------------
%% Permutation
[sz_x sz_y]=size(arg_matrix);
switch choice
    case 1
        ret_key=randperm(sz_x*sz_y);
        ret_sel=1;
    case 2
        clc;
        sz_blk=input('Enter the size of the block :');
        sz_blk_x=sz_x/sz_blk;
        sz_blk_y=sz_y/sz_blk;
        ret_key=randperm(sz_blk_x*sz_blk_y);
        ret_sel=2;
    otherwise
        fprintf('\nWrong choice');
end