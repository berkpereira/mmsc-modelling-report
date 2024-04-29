%% RELEVANT PARAM VALUES/RANGES
beta_range = linspace(0, 2e-8, 150);
T_infectious_range = linspace(0.5, 30, 150);

q_bounds = [0.1, 0.15, 0.2]';
sigma_bounds = [0.5, 0.65, 0.8]';
c_base = 7.95709e-8;
beta_highlights = c_base .* q_bounds .* sigma_bounds;


% eig_plot_surf(beta_range, T_infectious_range, beta_highlights)

% for T_latent = [0.2, 0.8, 2, 5, 10, 30]
%     eig_plot_surf_fixed(beta_range, T_infectious_range, beta_highlights, T_latent)
%     filename = ['eig-T_lat-' num2str(T_latent) '.pdf'];
%     exportgraphics(gcf, filename)
% end


R0_plot(beta_range, T_infectious_range, beta_highlights)
%exportgraphics(gcf, "R0.pdf")