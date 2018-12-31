% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 31 December 2018
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function out = get_the_line3(rotated_nose, land1, land2)

v = cross(land1 - land2, [0, 0, 1]);
out = intersectPlaneSurf(land1, v, rotated_nose(:, :, 1),...
    rotated_nose(:, :, 2), rotated_nose(:, :, 3));

out = curve_cropper(land1, land2, out);

