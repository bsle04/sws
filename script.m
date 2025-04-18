%Assignment: use the demographics data to create topoplots for each of the variables of APOE4 
% carriers vs. non-carriers; repeat this for V1 and V2: the final plots should look like 


%Destiny recommends writing some code to load in the demographics table as a data 
% matrix or array, take the “apoe4_Carrier” column -- and use that as the row index 
% to extract the carriers vs. non-carriers

%Then use the topoplot function inside of EEGLAB to draw the plots:
%One of them will be very similar to the plot below but with carriers vs. non-carriers
%The second plot will feature the annualized differences of carriers vs. non-carriers
%Note: 1 = carrier, 0=non-carrier in the APOE4_code column


matPath = 'C:\Users\Brandon\Repositories\sws\group\group\PAMMS_longitudinal_n29_SlowWavesSwitch_notLoggedTransformed.mat';
data = load(matPath);

demographicsPath = 'C:\Users\Brandon\Repositories\sws\masterDemographics_n29.xlsx';
demographics = readtable(demographicsPath);

% Initialize arrays for indices

indicesWith1 = find(demographics.apoe4_carrier == 1);
indicesWith0 = find(demographics.apoe4_carrier == 0);


disp(indicesWith0);
disp(indicesWith1);