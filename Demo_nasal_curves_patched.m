% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 31 December 2018
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function Demo_nasal_curves_patched
% This function is a demo for the nasal cureves feature extraction from
% the Gabor-wavelet filtered normal maps. It uses an uploaded 3D model of
% the nose. 
% After loading the landmarks, the function applies the Gabor-wavelets and
% computes the maximum per orientation.
% Then normal vectors are computed for each maximum scale image. And
% finally, the curves are computed over the nasal region and
% feature vectors are concatenated to form the final feature vector. 

clc
close all
warning off

curves_to_plot = 1;

%%%%%%%%%%%%% Loading the 2.5 depth map
load nasal_curve_landmarks.mat
input_data = rotated_nose;
figure, surf(input_data(:, :, 1), input_data(:, :, 2), input_data(:, :, 3), 'linestyle', 'none')
view(0, 90), camlight left, title('Input data')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% Setting up the landmarks over the depth map
%%%%%%%%% Name of curves
curves_name = {'L1 L2', 'L1 M1', 'L1 M2', 'L1 M3', 'L1 L3', 'L1 AL3', 'L1 AAL3', ...
    'L1 C', 'L1 M4', 'L1 L4', 'L1 L5', 'L1 L7', 'L1 M8', 'L1 M7', 'L1 M6', 'L1 L6', ...
    'L1 AL6', 'L1 AAL6', 'L1 M5', ...
    'L2 L7', 'L2 C', 'L2 L4', 'L2 L3', 'L2 AAL3', 'L2 M7', 'L2 M8', ...
    'L7 C', 'L7 L4', 'L7 L6', 'L7 AAL6', 'L7 M2', 'L7 M1', ...
    'M1 C', 'M2 C', 'M3 C', 'L3 C', 'AL3 C', 'AAL3 C', 'L4 C', 'M8 C', 'M7 C', 'M6 C', ...
    'L6 C', 'AL6 C', 'AAL6 C', ...
    'L4 M1', 'L4 M2', 'L4 M3', 'L4 L3', 'L4 AL3', 'L4 AAL3', 'L4 L5', 'L4 AAL6', 'L4 AL6', ...
    'L4 M6', 'L4 M7', 'L4 M8', ...
    'M4 M2', 'M4 M3', 'M4 M7', ...
    'M5 M7', 'M5 M6', 'M5 M2', ...
    'M1 M8', 'M2 M7', 'M3 M6', 'L3 L6', 'AL3 AL6', 'AAL3 AAL6', ...
    'AAL3 L5', 'AAL6 L5', ...
    'M2 L6', 'M7 L3'};
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% Plotting the landmarks
figure(1)
my_landmarks = [L1; L2; L3; L4; L5; L6; L7; M1; M2; M3; M4; M5; M6; M7; M8; C; AL3; AL6; AAL3; AAL6];
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

%%%%%%%%%%%%%%%% Computing the feature space as the histogram of the nasal
%%%%%%%%%%%%%%%% curves
all_feats = [];
hist_bins = [0: 1: 10];
subplot_cnt = 1;
for layer_cnt = 1: length(all_normal_maps)
    curr_layer3D = rotated_nose;
    curr_norm = all_normal_maps{layer_cnt};
    N1 = curr_norm(:, :, 1);
    N2 = curr_norm(:, :, 2);
    N3 = curr_norm(:, :, 3);

    for norm_cnt = 1: 3
        curr_layer3D(:, :, 3) = eval(['N' num2str(norm_cnt)]);

        if curves_to_plot == 1
            figure(4), subplot(length(all_normal_maps), 3, subplot_cnt),
            surf(curr_layer3D(:, :, 1), curr_layer3D(:, :, 2), curr_layer3D(:, :, 3), 'linestyle', 'none')
            view(0, 90), camlight left
        end
        
        for curve_cnt = 1: length(curves_name)
            curr_curve = curves_name{curve_cnt};
            locs = regexp(curr_curve, ' ');
            Start = curr_curve(1: locs - 1);
            End = curr_curve(locs + 1: end);

            out = get_the_line3(curr_layer3D, eval(Start), eval(End));

            if curves_to_plot == 1
                subplot(length(all_normal_maps), 3, subplot_cnt), hold on,
                plot3(out(:, 1), out(:, 2), out(:, 3), '.b')
            end
            curr_feat = out(:, 3); curr_feat = curr_feat - min(curr_feat);
            curr_feat = (curr_feat./ max(curr_feat))*10;
            curr_feat = hist(curr_feat, hist_bins); curr_feat = curr_feat./ (max(curr_feat) + eps);

            all_feats = [all_feats, curr_feat];
        end
        if curves_to_plot == 1
            title(['Gabor layer = ' num2str(layer_cnt) sprintf('\n') 'Normal dimension = ' num2str(norm_cnt)])
            subplot_cnt = subplot_cnt + 1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% Plotting the feature space
figure, plot(all_feats), ylim([0, 1.5]), title('Extracted feature vector')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%