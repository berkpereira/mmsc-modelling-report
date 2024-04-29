function eig_plot_line(beta_range)
%PLOT_INTERACTIVE_LINE Creates a 2D interactive plot with sliders for T_latent and T_infectious
% This function plots the dominant eigenvalue's real part against beta.

% Initial parameter values
T_latent = 2.5; % Initial value, adjustable via slider
T_infectious = 5; % Initial value, adjustable via slider
N = 51933100; % Example population, fixed
log10_I0 = 1; % Example value, assuming I0 does not vary in this setup

% Create a figure for the plot and sliders with increased height
% fig = figure('Name', 'Interactive Line Plot', 'NumberTitle', 'off', 'Position', [100, 100, 800, 700]);

% Adjust slider positions to be lower in the figure
T_latentSlider = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [100, 60, 300, 20], ...
                           'value', T_latent, 'min', 0.5, 'max', 20, 'SliderStep', [0.01 0.1], ...
                           'Callback', @(es,ed) updatePlot());

T_infectiousSlider = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [100, 30, 300, 20], ...
                               'value', T_infectious, 'min', 0.5, 'max', 20, 'SliderStep', [0.01 0.1], ...
                               'Callback', @(es,ed) updatePlot());

% Labels remain in the same relative position to their sliders
uicontrol('Parent', fig, 'Style', 'text', 'Position', [50, 60, 50, 20], 'String', 'T_latent');
uicontrol('Parent', fig, 'Style', 'text', 'Position', [50, 30, 80, 20], 'String', 'T_infectious');

% Nested function for updating the plot based on slider values
function updatePlot()
    T_latent = T_latentSlider.Value;
    T_infectious = T_infectiousSlider.Value;
    
    dominant_eigenvalue_real_part = zeros(1, length(beta_range));
    
    for i = 1:length(beta_range)
        beta = beta_range(i);
        J = make_jacobian(T_latent, T_infectious, beta, N, log10_I0);
        eigenvalues = eig(J);
        dominant_eigenvalue_real_part(i) = max(real(eigenvalues));
    end
    
    plot(beta_range, dominant_eigenvalue_real_part, 'LineWidth', 2);
    xlabel('beta');
    ylabel('Dominant Eigenvalue (Real Part)');
    title('Dominant Eigenvalue vs. Beta');
    grid on;
end

% Initial call to updatePlot to display the initial plot
updatePlot();
end
