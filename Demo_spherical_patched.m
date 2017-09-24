% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 25 June 2017
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function Demo_spherical_patched
% This function is a demo for the spherical patches feature extraction from
% the Gabor-wavelet filtered normal maps. It uses an uploaded 3D model of
% the nose. It can work in two modes: (1) uniformly selected landmarks and
% (2) nasal landmarks explained in the above PAMI paper.
% After loading the landmarks, it then applies the Gabor-wavelets and
% computes the maximum per orientation.
% Then normal vectors are computed for each maximum scale image. And
% finally, the spherical patches are computed over the nasal region and
% feature vectors are concatenated to form the final feature vector. 

clc
close all
clear all
warning off

%%%%%%%%%%%%% Loading the 2.5 depth map
load Sample_Nose.mat
input_data = rotated_nose;
figure, surf(input_data(:, :, 1), input_data(:, :, 2), input_data(:, :, 3), 'linestyle', 'none')
view(0, 90), camlight left, title('Input data')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% Setting up the landmarks over the depth map
Using_uniform_landmarks = false;
if Using_uniform_landmarks
    my_x_res = 5;
    my_y_res = 6.5;
    my_landmarks = create_uniform_landmarks(input_data, my_x_res, my_y_res);
else
    vertical_div = 5;
    horiz_div = 5;
    my_landmarks = create_landmarks(input_data, L1, L2, E1, E2, N, TIP, SADDLE, vertical_div, horiz_div);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% Plotting the landmarks
figure(1)
hold on,
plot3(my_landmarks(:, 1), my_landmarks(:, 2), my_landmarks(:, 3), 'r.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% Computing the Gabor-wavelets
max_ori = 4;
max_scale = 4;
all_layers = Gabor_wavelet_computer(input_data, max_ori, max_scale);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Plotting the Gabor-wavelet output
figure('Name', 'Maximal Gabor-wavelet outputs per orientation', 'NumberTitle','off');
subplot(2, 2, 1),
imagesc(all_layers(:, :, 1))
subplot(2, 2, 2),
imagesc(all_layers(:, :, 2))
subplot(2, 2, 3),
imagesc(all_layers(:, :, 3))
subplot(2, 2, 4),
imagesc(all_layers(:, :, 4))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Computing the normal vectors
all_normal_maps = Normal_vector_computer(input_data(:, :, 1), input_data(:, :, 2), all_layers);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Plotting the normal maps
figure('Name', 'Normal maps plot', 'NumberTitle','off')
for map_cnt = 1: length(all_normal_maps)
    curr_map = all_normal_maps{map_cnt};
    subplot(2, 2, map_cnt),
    imagesc(curr_map)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Computing the feature space as the histogram of the spherical patches
R = 11;
hist_bins = [-1: 0.1: 1];
toDisplay = 1;
all_feat = feature_extraction_spheres(input_data(:, :, 1), input_data(:, :, 2), input_data(:, :, 3), my_landmarks, all_normal_maps, R, hist_bins, toDisplay);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% Plotting the feature space
figure, plot(all_feat), ylim([0, 1.5]), title('Extracted feature vector')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%