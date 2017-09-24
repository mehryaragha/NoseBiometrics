% Written by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 25 June 2017
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function my_landmarks = create_landmarks(input_data, L1, L2, E1, E2, N, TIP, SADDLE, vertical_div, horiz_div);
% Loading the nasal landmarks.
% Only to be used when the input is a cropped nasal region. It uses nasal
% alar groove (L1 and L2), nasal tip (TIP), nasal root (SADDLE), subnasale
% (N) to create the set of landmarks according to the PAMI papers, using
% the desired division assigned by vertical_div and horiz_div variables.

L3 = L1;
L6 = L2;
L1 = SADDLE;
L2 = E1;
L4 = TIP;
L5 = N;
L7 = E2;
rotated_nose = input_data;
new_point = L3(1: 2) + ((L3(1: 2) - L1(1: 2))./norm(L3(1: 2) -...
    L1(1: 2)))* (norm(L3(1: 2) - L1(1: 2))/6);
% Map the new point on the nose surface
curr_dist = ...
    ((new_point(1) - rotated_nose(:, :, 1)).^ 2) + (new_point(2) - rotated_nose(:, :, 2)).^ 2;
[r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
new_point = rotated_nose(r, c, :); new_point = new_point(:)';
AL3 = new_point;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Find the one at the bottom of L6
new_point = L6(1: 2) + ((L6(1: 2) - L1(1: 2))./norm(L1(1: 2) -...
    L6(1: 2)))* (norm(L1(1: 2) - L6(1: 2))/6);
% Map the new point on the nose surface
curr_dist = ...
    ((new_point(1) - rotated_nose(:, :, 1)).^ 2) + (new_point(2) - rotated_nose(:, :, 2)).^ 2;
[r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
new_point = rotated_nose(r, c, :); new_point = new_point(:)';
AL6 = new_point;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Find the one at the bottom of AL3
new_point = AL3(1: 2) + ((AL3(1: 2) - L1(1: 2))./norm(AL3(1: 2) -...
    L1(1: 2)))* (norm(L3(1: 2) - L1(1: 2))/6);
% Map the new point on the nose surface
curr_dist = ...
    ((new_point(1) - rotated_nose(:, :, 1)).^ 2) + (new_point(2) - rotated_nose(:, :, 2)).^ 2;
[r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
new_point = rotated_nose(r, c, :); new_point = new_point(:)';
AAL3 = new_point;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Find the one at the bottom of AL6
new_point = AL6(1: 2) + ((AL6(1: 2) - L1(1: 2))./norm(L1(1: 2) -...
    AL6(1: 2)))* (norm(L1(1: 2) - L6(1: 2))/6);
% Map the new point on the nose surface
curr_dist = ...
    ((new_point(1) - rotated_nose(:, :, 1)).^ 2) + (new_point(2) - rotated_nose(:, :, 2)).^ 2;
[r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
new_point = rotated_nose(r, c, :); new_point = new_point(:)';
AAL6 = new_point;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% Finding the horizontal landmarks between L1 and L3 - L7 and
%%%%%% L6
dividing_vector = (L3 - L2)/ vertical_div;
all_between_L3_and_L2 = [];
curr_point = L2;
for vertical_land_cnt = 1: (vertical_div - 1)
    curr_point = curr_point + dividing_vector;
    % Map to the found landmark to the nose surface
    curr_dist = ...
        ((curr_point(1) - rotated_nose(:, :, 1)).^ 2) + (curr_point(2) - rotated_nose(:, :, 2)).^ 2;
    [r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
    new_point = rotated_nose(r, c, :); new_point = new_point(:)';
    all_between_L3_and_L2(vertical_land_cnt, :) = new_point;
end

%         figure(1), surf(rotated_nose(:, :, 1), rotated_nose(:, :, 2), rotated_nose(:, :, 3)),
%         hold on, plot3(all_between_L3_and_L2(:, 1), all_between_L3_and_L2(:, 2), all_between_L3_and_L2(:, 3), '.g')
%         plot3(L2(1), L2(2), L2(3), 'r.')
%         plot3(L3(1), L3(2), L3(3), 'r.')
%         plot3(AL3(1), AL3(2), AL3(3), 'r.')
%         plot3(AAL3(1), AAL3(2), AAL3(3), 'r.')

dividing_vector = (L6 - L7)/ vertical_div;
all_between_L6_and_L7 = [];
curr_point = L7;
for vertical_land_cnt = 1: (vertical_div - 1)
    curr_point = curr_point + dividing_vector;
    % Map to the found landmark to the nose surface
    curr_dist = ...
        ((curr_point(1) - rotated_nose(:, :, 1)).^ 2) + (curr_point(2) - rotated_nose(:, :, 2)).^ 2;
    [r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
    new_point = rotated_nose(r, c, :); new_point = new_point(:)';
    all_between_L6_and_L7(vertical_land_cnt, :) = new_point;
end

%         plot3(all_between_L6_and_L7(:, 1), all_between_L6_and_L7(:, 2), all_between_L6_and_L7(:, 3), 'g.')
%         plot3(L7(1), L7(2), L7(3), 'r.')
%         plot3(L6(1), L6(2), L6(3), 'r.')
%         plot3(AL6(1), AL6(2), AL6(3), 'r.')
%         plot3(AAL6(1), AAL6(2), AAL6(3), 'r.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%% Find points between L1 and L4

dividing_vector = (L4 - L1)/ vertical_div;
all_between_L1_and_L4 = [];
curr_point = L1;
for vertical_land_cnt = 1: (vertical_div - 1)
    curr_point = curr_point + dividing_vector;
    % Map to the found landmark to the nose surface
    curr_dist = ...
        ((curr_point(1) - rotated_nose(:, :, 1)).^ 2) + (curr_point(2) - rotated_nose(:, :, 2)).^ 2;
    [r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
    new_point = rotated_nose(r, c, :); new_point = new_point(:)';
    all_between_L1_and_L4(vertical_land_cnt, :) = new_point;
end

%         plot3(all_between_L1_and_L4(:, 1), all_between_L1_and_L4(:, 2), all_between_L1_and_L4(:, 3), 'g.')
%         plot3(L1(1), L1(2), L1(3), 'r.')
%         plot3(L4(1), L4(2), L4(3), 'r.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Find one point between L4 and L5
dividing_vector = (L5 - L4)/ 2;
curr_point = L4;
curr_point = curr_point + dividing_vector;
% Map to the found landmark to the nose surface
curr_dist = ...
    ((curr_point(1) - rotated_nose(:, :, 1)).^ 2) + (curr_point(2) - rotated_nose(:, :, 2)).^ 2;
[r, c] = find(curr_dist == min(curr_dist(:))); r = r(1); c = c(1);
new_point = rotated_nose(r, c, :); new_point = new_point(:)';
one_point_between_L4_and_L5 = new_point;
%         plot3(L4(1), L4(2), L4(3), 'r.')
%         plot3(L5(1), L5(2), L5(3), 'r.')
%         plot3(one_point_between_L4_and_L5(1), one_point_between_L4_and_L5(2), one_point_between_L4_and_L5(3), 'g.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% Save the points as left, central and right hand side
left_points = [L2; all_between_L3_and_L2; L3; AL3; AAL3];
centre_points = [L1; all_between_L1_and_L4; L4; one_point_between_L4_and_L5; L5];
right_points = [L7; all_between_L6_and_L7; L6; AL6; AAL6];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Compute the horizontal divisions
left_hand_horiz_landmarks = [];
right_hand_horiz_landmarks = [];
for vertical_pair_cnt = 1: size(centre_points, 1)
    left_hand_horiz_landmarks = [left_hand_horiz_landmarks;
        compute_mid_points(centre_points(vertical_pair_cnt, :), left_points(vertical_pair_cnt, :), horiz_div, rotated_nose)];
    right_hand_horiz_landmarks = [right_hand_horiz_landmarks;
        compute_mid_points(centre_points(vertical_pair_cnt, :), right_points(vertical_pair_cnt, :), horiz_div, rotated_nose)];
end

%         plot3(left_hand_horiz_landmarks(:, 1), left_hand_horiz_landmarks(:, 2), left_hand_horiz_landmarks(:, 3), '.y')
%         plot3(right_hand_horiz_landmarks(:, 1), right_hand_horiz_landmarks(:, 2), right_hand_horiz_landmarks(:, 3), '.y')
%         view(0, 90)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% Stacking all the landmarks
my_landmarks = [left_points; centre_points; right_points;...
    left_hand_horiz_landmarks; right_hand_horiz_landmarks];
%         figure(2), surf(rotated_nose(:, :, 1), rotated_nose(:, :, 2), rotated_nose(:, :, 3))
%         hold on, plot3(all_landmarks(:, 1), all_landmarks(:, 2), all_landmarks(:, 3), '.g')
%         view(0, 90)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%