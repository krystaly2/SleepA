% ------------------------------------------------------------
% signal data
% ------------------------------------------------------------
[PSG1_header,PSG1_data] = edfread('SC4001E0-PSG.edf');
time_duration_sec = length(PSG1_data)/100;
start_time = getfield(PSG1_header,'starttime');
start_time = strrep(start_time,'.00','');
start_time = str2double(start_time);
start_hr = fix(start_time);
start_min = fix((start_time - start_hr) * 100);

n = 100;
t = linspace(0,time_duration_sec-1,length(PSG1_data)/n);
figure;
subplot(4,1,1);
% take an average of each signal
filtered_data = signal_avg(PSG1_data(1,:),n);
plot(t,filtered_data,'r');
legend('EMG, EEGFpzCz');
hold all;
subplot(4,1,2);
filtered_data = signal_avg(PSG1_data(2,:),n);
plot(t,filtered_data,'b');
legend('EMG, EEGPzOz');
hold all;
subplot(4,1,3);
filtered_data = signal_avg(PSG1_data(3,:),n);
plot(t,filtered_data,'g');
legend('EOG, horizontal');
hold all;

% ------------------------------------------------------------
% Hypnogram data
% ------------------------------------------------------------
[Hypnogram_header,Hypnogram_data] = edfread('SC4001EC-Hypnogram.edf');
subjects = xlsread('SC-subjects.xls');
hyp_start_time = subjects(1,5) * 24;
hvp_start_hr = fix(hyp_start_time);
hvp_start_min = fix((hyp_start_time - hvp_start_hr) * 60);

% determine offset of hypnogram in relation to signal data
initial_offset_sec = (24 - start_hr) * 60 - start_min;
if (hvp_start_hr * 60 + hvp_start_min <= start_hr * 60 + start_min)
    initial_offset_sec = initial_offset_sec + hvp_start_hr * 60 + hvp_start_min;
else
    initial_offset_sec = hvp_start_hr * 60 + hvp_start_min - (start_hr * 60 + start_min);
end
initial_offset_sec = fix(initial_offset_sec*60);
% 10 is an arbitrary sampling rate
x = 10;
end_offset_sec = time_duration_sec - initial_offset_sec - length(Hypnogram_data)*x;
awake_initial = zeros(1,fix(initial_offset_sec/x));
awake_initial(:,:) = 0.5;
awake_end = zeros(1,round(end_offset_sec/x,0));
awake_end(:,:) = 0.5;
% pad hypnogram with "awake" stages
Hypnogram_data_extended = [awake_initial Hypnogram_data awake_end];

t2 = linspace(0,time_duration_sec-1,length(Hypnogram_data_extended));
subplot(4,1,4);
stairs(t2,round(Hypnogram_data_extended,1),'k');
hold all;
axis([0 time_duration_sec-1 min(Hypnogram_data_extended)-0.2 max(Hypnogram_data_extended)+0.2]);
legend('Hypnogram');