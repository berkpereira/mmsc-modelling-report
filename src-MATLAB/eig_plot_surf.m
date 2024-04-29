function eig_plot_surf(beta_range, T_infectious_range, beta_highlights)
%INTERACTIVE_PLOT Creates an interactive plot with sliders for T_latent and log10_I0
% This function plots the dominant eigenvalue against beta and T_infectious ranges,
% using sliders to adjust T_latent and log10_I0.

FONT_SIZE = 22;

% Initial parameter values
T_latent = 0.8; % This will be adjustable via slider
log10_I0 = -1e9; % Adjusted for a more reasonable default value
N = 51933100; % Example population, fixed

% Create a figure for the plot and sliders
fig = figure('Name', 'Interactive Dominant Eigenvalue Plot', 'NumberTitle', 'off', ...
    'Position', [100, 200, 1000, 1400]);

% view(3); % Set the initial 3D view

slider_position = [80, 30, 300, 23];
% Slider for adjusting T_latent
T_latentSlider = uicontrol('Parent', fig, 'Style', 'slider', 'Position', slider_position, ...
                         'value', T_latent, 'min', 0.1, 'max', 30, 'SliderStep', [0.01 0.1], ...
                         'Callback', @(es,ed) updatePlot());

% Dynamic text labels initialized with the sliders' initial values
T_latentValueLabel = uicontrol('Parent', fig, 'Style', 'text', 'Position', ...
    [slider_position(1)+slider_position(3) + 20, slider_position(2) + 5, 120, slider_position(4)], ...
                             'String', ['T_{latent}: ', num2str(T_latent)], FontSize=FONT_SIZE);

% Nested function for updating the plot based on slider values
function updatePlot()
    % Retrieve the current view settings before updating the plot
    % [az, el] = view;

    % Update slider values
    T_latent = T_latentSlider.Value;

    % Update dynamic text labels with current slider values
    T_latentValueLabel.String = ['T_latent: ', num2str(T_latent, '%.2f')];

    % Preallocate the grid for dominant eigenvalues
    dominant_eigenvalue_grid = zeros(length(T_infectious_range), length(beta_range));

    % Iterate over all combinations of beta and T_infectious
    for i = 1:length(T_infectious_range)
        for j = 1:length(beta_range)
            beta = beta_range(j);
            T_infectious = T_infectious_range(i);
            % Call the updated make_jacobian function
            J = make_jacobian(T_latent, T_infectious, beta, N, log10_I0);
            eigenvalues = eig(J);
            [~, idx] = max(real(eigenvalues));
            dominant_eigenvalue_grid(i, j) = eigenvalues(idx);
        end
    end

    % Plot the updated results
    contourf(beta_range, T_infectious_range, real(dominant_eigenvalue_grid), 20, 'LineStyle','None');
    
    hold on
    % Add contour at the level where the dominant eigenvalue is zero
    epsilon = 1e-7; % Example small positive value
    contour3(beta_range, T_infectious_range, real(dominant_eigenvalue_grid), [epsilon, epsilon], 'y', 'LineWidth', 3);
    
    for beta_tick = beta_highlights
        line([beta_tick beta_tick], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 4); % Draws a dashed line
    end
    
    hold off

    set(gca, 'FontSize', FONT_SIZE);

    xlabel('beta (contact * individual^{-2})', FontSize=FONT_SIZE);
    ylabel('T_{infectious} (days)', FontSize=FONT_SIZE);
    zlabel('Dominant Eigenvalue (Real Part)', FontSize=FONT_SIZE);
    title('Dominant Eigenvalue vs. (beta, T_{infectious})', FontSize=FONT_SIZE);
    colorbar; % Adds a colorbar to indicate the value scale
    
    % Reapply the previously captured view settings to preserve the user's view adjustments
    % view(az, el);
    
end

% Trigger initial plot rendering
updatePlot();

end
