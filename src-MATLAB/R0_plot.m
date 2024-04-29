function R0_plot(beta_range, T_infectious_range, beta_highlights)
%R0_PLOT Plots the basic reproduction number R0 as a color contour map
% This function plots contours of R0 against beta and T_infectious ranges.

FONT_SIZE = 25;
N = 51933100; % Example population, fixed

% Create a figure for the plot
fig = figure('Name', 'R0 Contour Plot', 'NumberTitle', 'off', ...
    'Position', [100, 200, 1000, 1400]);

% Preallocate the grid for R0 values
R0_grid = zeros(length(T_infectious_range), length(beta_range));

% Calculate R0 values over all combinations of beta and T_infectious
for i = 1:length(T_infectious_range)
    for j = 1:length(beta_range)
        beta = beta_range(j);
        T_infectious = T_infectious_range(i);
        R0_grid(i, j) = beta * T_infectious * N;
    end
end

% Plot the R0 values as a color contour map
contourf(beta_range, T_infectious_range, R0_grid, 20, 'LineStyle', 'none')

colorbar; % Adds a colorbar to indicate the value scale
hold on;

% Add contour at the level where R0 is just above 1 to show the threshold
epsilon = 1e-7; % Small positive value above 1
contour(beta_range, T_infectious_range, R0_grid, [1+epsilon, 1+epsilon], 'y', 'LineWidth', 3);

for beta_tick = beta_highlights
    line([beta_tick beta_tick], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 4); % Draws a dashed line
end

hold off;

% Set font size for the current axes
set(gca, 'FontSize', FONT_SIZE);

% Set labels and title with increased font size
xlabel('$c \, q \, \sigma$ (contact $\cdot$ individual$^{-2}$)', ...
    'FontSize', FONT_SIZE, 'Interpreter', 'latex');


ylabel('T_{infectious} (days)', 'FontSize', FONT_SIZE);
title('R_0', 'FontSize', FONT_SIZE);

end

