%%
%v1 carriers vs noncarries

V1 = data.grp.grpV1;
chanlocs = data.chanlocs;

carrierIdx = find(demographics.apoe4_carrier == 1);
nonCarrierIdx = find(demographics.apoe4_carrier == 0);

validChanIdx = find(arrayfun(@(c) isfield(c, 'labels') && ~isempty(c.labels), chanlocs));
chanlocs_valid = chanlocs(validChanIdx);

metricFields = {'sw_num', 'sw_dens', 'sw_freq', 'sw_trans_freq'};
metricLabels = {'SW Count', 'SW Density', 'SW Frequency', 'SW Transition Frequency'};

figure('Position', [100, 100, 1200, 800]);

for m = 1:length(metricFields)
    field = metricFields{m};
    label = metricLabels{m};

    %transpose to channels × subjects
    V1_data = V1.(field)';

    %find means
    carrier_mean = mean(V1_data(:, carrierIdx), 2);
    noncarrier_mean = mean(V1_data(:, nonCarrierIdx), 2);
    all_mean = mean(V1_data, 2);

    %reduce to valid channels
    carrier_mean = carrier_mean(validChanIdx);
    noncarrier_mean = noncarrier_mean(validChanIdx);
    all_mean = all_mean(validChanIdx);

    row = m - 1;

    subplot(4, 3, row * 3 + 1);
    topoplot(carrier_mean, chanlocs_valid);
    title([label ' - Carrier']);
    colorbar;

    subplot(4, 3, row * 3 + 2);
    topoplot(noncarrier_mean, chanlocs_valid);
    title([label ' - Non-Carrier']);
    colorbar;

    subplot(4, 3, row * 3 + 3);
    topoplot(all_mean, chanlocs_valid);
    title([label ' - All Subjects']);
    colorbar;
end

sgtitle('V1 Topoplots by APOE4 Carrier Status', 'FontSize', 16);

%%
%v2 carriers vs non carriers
V2 = data.grp.grpV2;

figure('Position', [100, 100, 1200, 800]);

for m = 1:length(metricFields)
    field = metricFields{m};
    label = metricLabels{m};

    %transpose to channels × subjects
    V2_data = V2.(field)';

    %find means
    carrier_mean = mean(V2_data(:, carrierIdx), 2);
    noncarrier_mean = mean(V2_data(:, nonCarrierIdx), 2);
    all_mean = mean(V2_data, 2);

    %reduce to valid channels
    carrier_mean = carrier_mean(validChanIdx);
    noncarrier_mean = noncarrier_mean(validChanIdx);
    all_mean = all_mean(validChanIdx);

    row = m - 1;

    subplot(4, 3, row * 3 + 1);
    topoplot(carrier_mean, chanlocs_valid);
    title([label ' - Carrier']);
    colorbar;

    subplot(4, 3, row * 3 + 2);
    topoplot(noncarrier_mean, chanlocs_valid);
    title([label ' - Non-Carrier']);
    colorbar;

    subplot(4, 3, row * 3 + 3);
    topoplot(all_mean, chanlocs_valid);
    title([label ' - All Subjects']);
    colorbar;
end

sgtitle('V2 Topoplots by APOE4 Carrier Status', 'FontSize', 16);


%%
%annualDiffs

annualDiffs = data.grp.annualDiffs;

figure('Position', [100, 100, 900, 800]);

for m = 1:length(metricFields)
    field = metricFields{m};
    label = metricLabels{m};

    ann_data = annualDiffs.(field);  % already channels x subjects?

    % If needed: transpose (double check shape)
    if size(ann_data, 2) == 206
        ann_data = ann_data';
    end

    %compute group mean difference
    diffMap = mean(ann_data(:, carrierIdx), 2) - mean(ann_data(:, nonCarrierIdx), 2);
    diffMap = diffMap(validChanIdx);

    subplot(2, 2, m);
    topoplot(diffMap, chanlocs_valid);
    title([label ' - Annualized Difference (Carrier - Non-Carrier)']);
    colorbar;
end

sgtitle('Annualized Differences in SW Metrics by APOE4 Status', 'FontSize', 16);
