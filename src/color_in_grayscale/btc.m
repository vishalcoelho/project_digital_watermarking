%--------------------------------------------------------------------------
% Function      : btc.m
% Purpose       : Take an input matrix and find the btc of it
%--------------------------------------------------------------------------
%% Functions
%   1. bit_plane.m
%--------------------------------------------------------------------------
function ret_bitplane=btc(arg_matrix)
%--------------------------------------------------------------------------
% Note: This function generates the compressed bit plane along with the
%       first and second moments
%--------------------------------------------------------------------------
clc;
arg_blk_sz=input('What size BTC do you want: ');
ret_bitplane=bit_plane(arg_matrix,arg_blk_sz);
%--------------------------------------------------------------------------
%End of Funtion
%--------------------------------------------------------------------------
