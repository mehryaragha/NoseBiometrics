% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 25 June 2017
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function all_feat = feature_extraction_spheres(X, Y, Z, all_landmarks, all_normal_maps, R, hist_bins, toDisplay)
% This function uses spherical patches as feature descriptors to extract
% histograms of the normal maps computed over the Gabor-wavelet images.
% X and Y and Z are the 3D point cloud of the input image.
% all_landmarks is and M X 3 matrix containing the nasal landmarks
% all_normal_maps is a cell array containing the normal maps.
% R is the radius of the spherical patches in millimeters.
% hist_bins is a vector with elements between -1 and 1, used as histogram
% bins.
% toDisplay is a binary flag to show the output.

rotated_nose(:, :, 1) = X;
rotated_nose(:, :, 2) = Y;
rotated_nose(:, :, 3) = Z;
all_feat = [];

for layercnt = 1: length(all_normal_maps)
    curr_map = all_normal_maps{layercnt};
    Nx = curr_map(:, :, 1);
    Ny = curr_map(:, :, 2);
    Nz = curr_map(:, :, 3);
    all_curr_dist = false(size(Nx));
    
    
    for land_cnt = 1: size(all_landmarks, 1)
        curr_land = all_landmarks(land_cnt, :);
        
        %                 R = 11;
        % Crop a sphere around the landmark
        curr_dist = (rotated_nose(:, :, 1) - curr_land(1)).^ 2 + (rotated_nose(:, :, 2) - curr_land(2)).^ 2 + ...
            (rotated_nose(:, :, 3) - curr_land(3)).^ 2 < R^2;
        
        all_curr_dist = or(curr_dist, all_curr_dist);
        
        histx = hist(Nx(curr_dist), hist_bins); histx = histx/ max(histx);
        histy = hist(Ny(curr_dist), hist_bins); histy = histy/ max(histy);
        histz = hist(Nz(curr_dist), hist_bins); histz = histz/ max(histz);
        
        curr_set = [histx, histy, histz];
        
        
        all_feat = [all_feat, curr_set];
    end
end


if toDisplay
    [sphx, sphy, sphz] = sphere(50);
    figure('Name', 'Spherical patches', 'NumberTitle','off')
    surf(rotated_nose(:, :, 1), rotated_nose(:, :, 2), rotated_nose(:, :, 3), 'linestyle', 'none'),
    view(0, 90)
    for land_cnt = 1: size(all_landmarks, 1)
        curr_land = all_landmarks(land_cnt, :);
        hold on,
        surf(R* sphx + curr_land(1), R* sphy + curr_land(2), R* sphz + curr_land(3))
        hold off
    end
end
camlight left