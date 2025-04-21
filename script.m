% Load data and demographics
path = 'C:\Users\Brandon\Repositories\sws\group\group\PAMMS_longitudinal_n29_SlowWavesSwitch_notLoggedTransformed.mat';
data = load(path);

demographicsPath = 'C:\Users\Brandon\Repositories\sws\masterDemographics_n29.xlsx';
demographics = readtable(demographicsPath);
carrierIdx = find(demographics.apoe4_carrier == 1);
nonCarrierIdx = find(demographics.apoe4_carrier == 0);

% Channel locations
chanlocs = data.chanlocs;

% Find valid EEG channels
validChanIdx = find(arrayfun(@(c) isfield(c, 'labels') && ~isempty(c.labels), chanlocs));
chanlocs_valid = chanlocs(validChanIdx);

% Metric fields and labels
metricFields = {'sw_num', 'sw_dens', 'sw_freq', 'sw_trans_freq'};
metricLabels = {'SW Count', 'SW Density', 'SW Frequency', 'SW Transition Frequency'};

% Extract group data
V1 = data.grp.grpV1;
V2 = data.grp.grpV2;

figure('Position', [100, 100, 1600, 1000]);

for m = 1:length(metricFields)
    field = metricFields{m};
    label = metricLabels{m};

    % Data for current metric
    V1_data = V1.(field)';  % channels x subjects
    V2_data = V2.(field)';

    % Group means
    V1_carrier = mean(V1_data(:, carrierIdx), 2);
    V1_noncarrier = mean(V1_data(:, nonCarrierIdx), 2);
    V2_carrier = mean(V2_data(:, carrierIdx), 2);
    V2_noncarrier = mean(V2_data(:, nonCarrierIdx), 2);

    % Differences
    V1_diff = V1_carrier - V1_noncarrier;
    V2_diff = V2_carrier - V2_noncarrier;

    % Only keep valid channels
    V1_carrier = V1_carrier(validChanIdx);
    V1_noncarrier = V1_noncarrier(validChanIdx);
    V1_diff = V1_diff(validChanIdx);
    V2_carrier = V2_carrier(validChanIdx);
    V2_noncarrier = V2_noncarrier(validChanIdx);
    V2_diff = V2_diff(validChanIdx);

    % Plotting (6 plots per row)
    baseCol = 6;
    row = m - 1;

    subplot(4, baseCol, row * baseCol + 1);
    topoplot(V1_carrier, chanlocs_valid);
    title([label ' - V1 Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 2);
    topoplot(V1_noncarrier, chanlocs_valid);
    title([label ' - V1 Non-Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 3);
    topoplot(V1_diff, chanlocs_valid);
    title([label ' - V1 Difference']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 4);
    topoplot(V2_carrier, chanlocs_valid);
    title([label ' - V2 Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 5);
    topoplot(V2_noncarrier, chanlocs_valid);
    title([label ' - V2 Non-Carrier']);
    colorbar;

    subplot(4, baseCol, row * baseCol + 6);
    topoplot(V2_diff, chanlocs_valid);
    title([label ' - V2 Difference']);
    colorbar;
end

sgtitle('Topoplots: APOE4 Carriers vs. Non-Carriers - V1 & V2 with Differences', 'FontSize', 16);
