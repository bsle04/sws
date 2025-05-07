% Load data and demographics
path = 'C:\Users\Brandon\Repositories\sws\data\group\PAMMS_longitudinal_n29_SlowWavesSwitch_notLoggedTransformed.mat';
data = load(path);

demographicsPath = 'C:\Users\Brandon\Repositories\sws\data\masterDemographics_n29.xlsx';
demographics = readtable(demographicsPath);
carrierIdx = find(demographics.apoe4_carrier == 1);
nonCarrierIdx = find(demographics.apoe4_carrier == 0);

% Channel locations
chanlocs = data.chanlocs;

% Metric fields and labels
metricFields = {'sw_num', 'sw_dens', 'sw_freq', 'sw_trans_freq'};
metricLabels = {'SW Count', 'SW Density', 'SW Frequency', 'SW Transition Frequency'};

% Extract group data
V1 = data.grp.grpV1;
V2 = data.grp.grpV2;

% --- V1 & V2 Plots ---
figure('Position', [100, 100, 1600, 1000]);

for m = 1:length(metricFields)
    field = metricFields{m};
    label = metricLabels{m};

    % Data for current metric
    V1_data = V1.(field)';  % channels x subjects
    V2_data = V2.(field)';

    % Group means
    V1_carrier = mean(V1_data(:, carrierIdx), 2, 'omitnan');
    V1_noncarrier = mean(V1_data(:, nonCarrierIdx), 2, 'omitnan');
    V2_carrier = mean(V2_data(:, carrierIdx), 2, 'omitnan');
    V2_noncarrier = mean(V2_data(:, nonCarrierIdx), 2, 'omitnan');

    % Differences
    carrier_diff = V2_carrier - V1_carrier;
    noncarrier_diff = V2_noncarrier - V1_noncarrier;

    % Plotting (6 plots per row)
    baseCol = 6;
    row = m - 1;

    subplot(4, baseCol, row * baseCol + 1);
    topoplot(V1_carrier, chanlocs);
    title([label ' - V1 Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 2);
    topoplot(V1_noncarrier, chanlocs);
    title([label ' - V1 Non-Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 3);
    topoplot(carrier_diff, chanlocs);
    title([label ' - Carrier Difference']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 4);
    topoplot(V2_carrier, chanlocs);
    title([label ' - V2 Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 5);
    topoplot(V2_noncarrier, chanlocs);
    title([label ' - V2 Non-Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 6);
    topoplot(noncarrier_diff, chanlocs);
    title([label ' - Noncarrier Difference']);
    colorbar;
end

sgtitle('Topoplots: APOE4 Carriers vs. Non-Carriers - V1 & V2 with Differences', 'FontSize', 16);

% Save figure
saveas(gcf, 'C:\Users\Brandon\Repositories\sws\figures\Topoplots_APOE4_V1V2_Differences.png');