% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 25 June 2017
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function all_layers = Gabor_wavelet_computer(rotated_nose, max_ori, max_scale)
% This function obtains the 3D nose model rotated_nose, which is an M X N X
% 3 block matrix and computes the Gabor-wavelets using in max_ori 
% orientations and max_scale scales. Both max_ori and max_scale are
% scalars.

%%%%%%% First find different scales of Gabor filter.
curr_depth = rotated_nose(:, :, 3);
% Replacing the NaNs in the input by the nose's median
curr_depth(isnan(curr_depth)) = nanmedian(curr_depth(:));
curr_depth_f = fft2(curr_depth);

%         max_ori = 4;
%         max_scale = 4;
all_layers = zeros(size(curr_depth_f, 1), size(curr_depth_f, 2), max_scale);
for scale_cnt = 1: max_scale
    curr_layer = zeros(size(curr_depth_f, 1), size(curr_depth_f, 2), max_ori);
    for ori_cnt = 1: max_ori
        
        [Gr, Gi] = gabor_by_meshgrid(size(curr_depth),...
            [scale_cnt, ori_cnt], [0.05 1], [max_scale, max_ori], 0);
        
        % find the fft of the input and put its DC freq zero
        G_F = fft2(Gr + i*Gi);
        G_F(1, 1) = 0;
        
        curr_filtered_nose = abs(ifft2(curr_depth_f.* G_F));
        
        %                             curr_filtered_nose = gather(curr_filtered_nose);
        curr_layer(:, :, ori_cnt) = fftshift(curr_filtered_nose);
    end
    %                 all_layers(:, :, scale_cnt) = median(curr_layer, 3);
    all_layers(:, :, scale_cnt) = max(curr_layer, [], 3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%