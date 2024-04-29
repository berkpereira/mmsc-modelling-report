%% SET GRAPHICS PARAMETERS
set(groot, 'DefaultAxesFontName', 'Helvetica');  % Sets the default font for axes labels and ticks
set(groot, 'DefaultTextFontName', 'Helvetica');  % Sets the default font for text

set(groot, 'DefaultAxesFontSize', 10);     % Default font size for axes labels and ticks
set(groot, 'DefaultTextFontSize', 10);     % Default font size for text
set(groot, 'DefaultAxesTitleFontSizeMultiplier', 1);  % Multiplier for the title font size relative to axes font
set(groot, 'DefaultAxesLabelFontSizeMultiplier', 1);  % Multiplier for axes labels

clear
clc
close all

% Think in inches
PAGE_WIDTH = 5.9;
PLOT_HEIGHT = 2.2;


%% INPUTS
% Define the group and quantity
contour_group = 'highrisk'; % elderly or highrisk
quantity = 'PeakCaseNumbers'; % TotalIliNumbers or PeakCaseNumbers

SAVEFIG = true;

%% LOAD DATA
% Load data based on the group and quantity
if strcmp(contour_group, 'elderly')
    if strcmp(quantity, 'TotalIliNumbers')
        load('elderly-TotalIliNumbers-sensitivity-results.mat')
    elseif strcmp(quantity, 'PeakCaseNumbers')
        load('elderly-PeakCaseNumbers-sensitivity-results.mat')
    end
elseif strcmp(contour_group, 'highrisk')
    if strcmp(quantity, 'TotalIliNumbers')
        load('highrisk-TotalIliNumbers-sensitivity-results.mat')
    elseif strcmp(quantity, 'PeakCaseNumbers')
        load('highrisk-PeakCaseNumbers-sensitivity-results.mat')
    end
end

datamatrix = table2array(datamatrix);
delayvector = table2array(delayvector);
speedupvector = table2array(speedupvector);

baseline_speedup_index = find(abs(speedupvector - 1) < 0.01);
baseline_delay_index = find(delayvector == 0);

datamatrix_normalised = datamatrix ./ datamatrix(baseline_delay_index, baseline_speedup_index);

%% PLOT

% RANGE FOR COLOUR BAR
if strcmp(contour_group, 'highrisk') && strcmp(quantity, 'PeakCaseNumbers')
    low_c = 0.5;
    hi_c = 6.51;
else
    low_c = 0.5;
    hi_c = 2.5;
end

fig = figure;

[X, Y] = meshgrid(delayvector, speedupvector); % Create meshgrid for contour plot
contourf(X, Y, datamatrix_normalised', linspace(low_c, hi_c, 15)); % Create filled contour plot


colormap('hot'); % Optional: choose a colormap
colorbar; % Display a color bar


% Set the font size for the plot


% Set labels and title with the value of T_latent included
xlabel(['Vaccination Calendar' newline 'Delay (days)']);
ylabel(['Vaccination Calendar' newline 'Speedup']);

ax = gca;
ax.YTick = 0.8:0.2:2;

clim([low_c hi_c]);

% Define a dynamic title based on the current settings
if ~ SAVEFIG
    if strcmp(contour_group, 'elderly')
        if strcmp(quantity, 'TotalIliNumbers')
            plot_title = ['Normalised Total Number of' newline 'Cases in Season — Elderly'];
        elseif strcmp(quantity, 'PeakCaseNumbers')
            plot_title = ['Normalised Peak Weekly' newline 'Case Numbers — Elderly'];
        end
    elseif strcmp(contour_group, 'highrisk')
        if strcmp(quantity, 'TotalIliNumbers')
            plot_title = ['Normalised Total Number of' newline 'Cases in Season — High-Risk'];
        elseif strcmp(quantity, 'PeakCaseNumbers')
            plot_title = ['Normalised Peak Weekly' newline 'Case Numbers — High-Risk'];
        end
    end
    title(plot_title);
end

set(fig, 'Units', 'inches', 'Position', ...
    [0, 0, PAGE_WIDTH/2, PLOT_HEIGHT], 'NumberTitle', 'off');

%% SAVE PLOT if required
% Export the plot to a dynamically named PDF file
if SAVEFIG
    pdf_name = sprintf('~/OneDrive - Nexus365/ox-mmsc-cloud/modelling-report/report/plots/%s-%s-sensitivity.pdf', ...
        contour_group, quantity);
    exportgraphics(gcf, pdf_name);
end