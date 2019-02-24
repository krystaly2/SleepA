function [] = edf_to_csv(psgFileInput,psgFileOutput,hypFileInput, hypFileOutput)
% generate csv files for:
% 1. psgFile: filtered version
% 2. hypFile: original version

% ------------------------------------------------------------
% signal data
% ------------------------------------------------------------
[PSG1_header,PSG1_data] = edfread(psgFileInput);

sig_to_csv = [];
n = 100; % filter sample rate

% take an average of each signal
filtered_data = signal_avg(PSG1_data(1,:),n);
sig_to_csv(:,1) = filtered_data;

filtered_data = signal_avg(PSG1_data(2,:),n);
sig_to_csv(:,2) = filtered_data;

filtered_data = signal_avg(PSG1_data(3,:),n);
sig_to_csv(:,3) = filtered_data;

% convert to csv
csvwrite(psgFileOutput, sig_to_csv, 1);

% ------------------------------------------------------------
% Hypnogram data
% ------------------------------------------------------------
[Hypnogram_header,Hypnogram_data] = edfread(hypFileInput);
csvwrite(hypFileOutput, Hypnogram_data', 1);



end

