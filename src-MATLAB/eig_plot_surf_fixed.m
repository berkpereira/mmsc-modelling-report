function eig_plot_surf_fixed(beta_range, T_infectious_range, beta_highlights, T_latent)
%EIG_PLOT_SURF_FIXED Plots the dominant eigenvalue against beta and T_infectious ranges
% This function plots a color contour map of the dominant eigenvalue without interactivity.
% T_latent is set during the function call.

FONT_SIZE = 25;

% Fixed parameter values
log10_I0 = -1e9; % Adjusted for a more reasonable default value
N = 51933100; % Example population, fixed

% Create a figure for the plot
fig = figure('Name', 'Dominant Eigenvalue Plot', 'NumberTitle', 'off', ...
    'Position', [100, 200, 1000, 1400]);

% Preallocate the grid for dominant eigenvalues
dominant_eigenvalue_grid = zeros(length(T_infectious_range), length(beta_range));

% Iterate over all combinations of beta and T_infectious
for i = 1:length(T_infectious_range)
    for j = 1:length(beta_range)
        beta = beta_range(j);
        T_infectious = T_infectious_range(i);
        % Call the make_jacobian function (assumed to be defined elsewhere)
        J = make_jacobian(T_latent, T_infectious, beta, N, log10_I0);
        eigenvalues = eig(J);
        [~, idx] = max(real(eigenvalues));
        dominant_eigenvalue_grid(i, j) = eigenvalues(idx);
    end
end

% Plot the results
contourf(beta_range, T_infectious_range, real(dominant_eigenvalue_grid), 20, 'LineStyle', 'none');
colorbar; % Adds a colorbar to indicate the value scale

% Highlight specific beta values
hold on;
epsilon = 1e-7; % Small positive value to highlight where the eigenvalue is just above zero
contour(beta_range, T_infectious_range, real(dominant_eigenvalue_grid), [epsilon, epsilon], 'y', 'LineWidth', 3);
for beta_tick = beta_highlights
    line([beta_tick beta_tick], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 4); % Draws a dashed line
end
hold off;

% Set the font size for the plot
set(gca, 'FontSize', FONT_SIZE);

% Set labels and title with the value of T_latent included
xlabel('$c \, q \, \sigma$ (contact $\cdot$ individual$^{-2}$)', ...
    'FontSize', FONT_SIZE, 'Interpreter', 'latex');
ylabel('T_{infectious} (days)', 'FontSize', FONT_SIZE);
title(sprintf('Jacobian: Most Positive Eigenvalue Real Part when T_{latent} = %g days', T_latent), 'FontSize', FONT_SIZE);


end
