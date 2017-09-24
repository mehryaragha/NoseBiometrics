function my_landmarks = create_uniform_landmarks(input_data, my_x_res, my_y_res);
% This function creates a uniform set of landmarks over the depth map,
% given the desired X and Y resolution parameters.

input_x = input_data(:, :, 1);
input_y = input_data(:, :, 2);
input_z = input_data(:, :, 3);

nanmap = isnan(input_x) | isnan(input_y) | isnan(input_z);

[X, Y] = meshgrid(min(input_data(:)): my_x_res: max(input_data(:)), min(input_data(:)): my_y_res: max(input_data(:)));

F = scatteredInterpolant(input_x(~nanmap), input_y(~nanmap), input_z(~nanmap), 'linear', 'none');
Z = F(X, Y);

my_landmarks = [X(:), Y(:), Z(:)];

newNanMap = isnan(my_landmarks);
nanIND = find(sum(newNanMap, 2) > 0);
my_landmarks(nanIND, :) = [];
end

