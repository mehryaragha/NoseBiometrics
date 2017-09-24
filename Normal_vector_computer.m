% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 25 June 2017
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function all_normal_maps = Normal_vector_computer(X, Y, all_layers);
% This function gets X and Y which are the M X N matrices, containing the
% horizontal and vertical resolution matrices, and all_layers, which is a
% block matrix in the form of O X P X max_scale, and computes the normal
% maps for each scale maps. 
% The output all_normal_maps is a cell array containing the normal maps.

for layer_cnt = 1: size(all_layers, 3)
    [curr_norm_x, curr_norm_y, curr_norm_z] = ...
        surfnorm(X, Y, all_layers(:, :, layer_cnt));
    curr_norm(:, :, 1) = curr_norm_x;
    curr_norm(:, :, 2) = curr_norm_y;
    curr_norm(:, :, 3) = curr_norm_z;
    all_normal_maps{layer_cnt} = curr_norm;
end


