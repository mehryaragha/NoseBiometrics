% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 31 December 2018
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function cropped_out = curve_cropper(pnt1, pnt2, the_curve)

% [~, pnt1_idx] = min(sum((the_curve - repmat(pnt1, [size(the_curve, 1) 1])).^2, 2));
% [~, pnt2_idx] = min(sum((the_curve - repmat(pnt2, [size(the_curve, 1) 1])).^2, 2));

[~, pnt1_idx] = min(sum((the_curve(:, 1: 2) - repmat(pnt1(1: 2), [size(the_curve, 1) 1])).^2, 2));
[~, pnt2_idx] = min(sum((the_curve(:, 1: 2) - repmat(pnt2(1: 2), [size(the_curve, 1) 1])).^2, 2));


pnt_sorted = sort([pnt1_idx pnt2_idx], 'ascend');
cropped_out = the_curve(pnt_sorted(1): pnt_sorted(2), :);
