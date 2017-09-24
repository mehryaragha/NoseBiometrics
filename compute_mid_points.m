% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 25 June 2017
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function found_points = compute_mid_points(starting_pnt, end_pnt, number_of_divisions, rotated_nose);
% This function computes middle points to create the set of nasal landmarks
% according to the PAMI paper.

dividing_vector = (end_pnt - starting_pnt)/ number_of_divisions;
found_points = [];
curr_point = starting_pnt;
for land_cnt = 1: (number_of_divisions - 1)
    curr_point = curr_point + dividing_vector;
    % Map to the found landmark to the nose surface
    curr_dist = ...
        ((curr_point(1) - rotated_nose(:, :, 1)).^ 2) + (curr_point(2) - rotated_nose(:, :, 2)).^ 2;
    [r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
    new_point = rotated_nose(r, c, :); new_point = new_point(:)';
    found_points(land_cnt, :) = new_point;
end
end