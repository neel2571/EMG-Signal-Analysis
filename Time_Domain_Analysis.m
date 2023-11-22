% Load task data
file_path_task = '/MATLAB Drive/Project_4_Task.mat';
load(file_path_task);
muscle_signal_task = data;

% Load baseline data
file_path_baseline = '/MATLAB Drive/Project_4_Baseline.mat';
load(file_path_baseline);
muscle_signal_baseline = data;

% Common parameters
fs = 1000;
fnyq = fs/2;
num_samples_task = length(muscle_signal_task);
num_samples_baseline = length(muscle_signal_baseline);
time_task = (0:(num_samples_task - 1)) / fs;
time_baseline = (0:(num_samples_baseline - 1)) / fs;

% Baseline correction for task signal
muscle_signal_baseline_task = mean(muscle_signal_task);
muscle_signal_corrected_task = muscle_signal_task - muscle_signal_baseline_task;

% Baseline correction for baseline signal
muscle_signal_baseline_baseline = mean(muscle_signal_baseline);
muscle_signal_corrected_baseline = muscle_signal_baseline - muscle_signal_baseline_baseline;

% Plot raw task and baseline signals side by side
figure;

ax = subplot(2, 1, 1);
plot(time_task, muscle_signal_corrected_task);
title('Raw Task Signal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
set(ax,'YLim',[-1.2 1.2]);

ax = subplot(2, 1, 2);
plot(time_baseline, muscle_signal_corrected_baseline);
title('Raw Baseline Signal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
set(ax,'YLim',[-1.2 1.2]);

% Finding and plotting FFT for task signal
f_task = fs * (0:(num_samples_task/2))/num_samples_task;
fft_muscle_signal_task = fft(muscle_signal_corrected_task);
fft_muscle_signal_task = abs(fft_muscle_signal_task/num_samples_task);
fft_muscle_signal_task = fft_muscle_signal_task(1:num_samples_task/2+1);
fft_muscle_signal_task(2:end-1) = 2 * fft_muscle_signal_task(2:end-1);

% Finding and plotting FFT for baseline signal
f_baseline = fs * (0:(num_samples_baseline/2))/num_samples_baseline;
fft_muscle_signal_baseline = fft(muscle_signal_corrected_baseline);
fft_muscle_signal_baseline = abs(fft_muscle_signal_baseline/num_samples_baseline);
fft_muscle_signal_baseline = fft_muscle_signal_baseline(1:num_samples_baseline/2+1);
fft_muscle_signal_baseline(2:end-1) = 2 * fft_muscle_signal_baseline(2:end-1);

% Plot FFTs for task and baseline signals
figure;

ax = subplot(2, 1, 1);
plot(f_task, fft_muscle_signal_task);
title('Task Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
set(ax,'YLim',[0 0.01]);

ax = subplot(2, 1, 2);
plot(f_baseline, fft_muscle_signal_baseline);
title('Baseline Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
set(ax,'YLim',[0 0.01]);

%%% Notch Filter %%%

notchFrequency = 50; % Frequency to be removed (in Hz)
bandwidth = 25;       % Bandwidth of the notch filter (in Hz)

fft_o = fft(muscle_signal_corrected_task);
freqs_task = linspace(0, fs, length(fft_o));
wo = notchFrequency / (fs/2);
bw = bandwidth / (fs/2);
[bn, an] = iirnotch(wo, bw);

filteredSignalnotch_task = filter(bn, an, muscle_signal_corrected_task);
filteredFFTnotch_task = fft(filteredSignalnotch_task);
filteredFFTnotch_task = abs(filteredFFTnotch_task/num_samples_task);
filteredFFTnotch_task = filteredFFTnotch_task(1:num_samples_task/2+1);
filteredFFTnotch_task(2:end-1) = 2 * filteredFFTnotch_task(2:end-1);
frequenciesOriginalnotch_task = fs * (0:(num_samples_task/2))/num_samples_task;

notchFrequency = 50; % Frequency to be removed (in Hz)
bandwidth = 25;       % Bandwidth of the notch filter (in Hz)

fft_o = fft(muscle_signal_corrected_task);
freqs_baseline = linspace(0, fs, length(fft_o));
wo = notchFrequency / (fs/2);
bw = bandwidth / (fs/2);
[bn, an] = iirnotch(wo, bw);

filteredSignalnotch_baseline = filter(bn, an, muscle_signal_corrected_baseline);
filteredFFTnotch_baseline = fft(filteredSignalnotch_baseline);
filteredFFTnotch_baseline = abs(filteredFFTnotch_baseline/num_samples_baseline);
filteredFFTnotch_baseline = filteredFFTnotch_baseline(1:num_samples_baseline/2+1);
filteredFFTnotch_baseline(2:end-1) = 2 * filteredFFTnotch_baseline(2:end-1);
frequenciesOriginalnotch_baseline = fs * (0:(num_samples_baseline/2))/num_samples_baseline;

% Plot FFTs for task and baseline signals
figure;

ax = subplot(2, 1, 1);
plot(frequenciesOriginalnotch_task, filteredFFTnotch_task);
title('Task Signal Spectrum');
xlabel('Frequency (Hz)');
xlim([0 500]);
ylabel('Magnitude');
set(ax,'YLim',[0 0.01]);

ax = subplot(2, 1, 2);
plot(frequenciesOriginalnotch_baseline, filteredFFTnotch_baseline);
title('Baseline Signal Spectrum');
xlabel('Frequency (Hz)');
xlim([0 500]);
ylabel('Magnitude');
set(ax,'YLim',[0 0.01]);

% BP filter for task signal
fcuthigh_task = 10;
fcutlow_task = 300;
[b_task, a_task] = butter(4, [fcuthigh_task, fcutlow_task]/fnyq, 'bandpass');
muscle_signal_filtered_task = filtfilt(b_task, a_task, filteredSignalnotch_task);
% muscle_signal_filtered_task = abs(muscle_signal_filtered_task);

% BP filter for baseline signal
fcuthigh_baseline = 10;
fcutlow_baseline = 100;
[b_baseline, a_baseline] = butter(4, [fcuthigh_baseline, fcutlow_baseline]/fnyq, 'bandpass');
muscle_signal_filtered_baseline = filtfilt(b_baseline, a_baseline, filteredSignalnotch_baseline);
% muscle_signal_filtered_baseline = abs(muscle_signal_filtered_baseline);

% Finding and plotting FFT for task signal
f_task = fs * (0:(num_samples_task/2))/num_samples_task;
fft_muscle_signal_task = fft(muscle_signal_filtered_task);
fft_muscle_signal_task = abs(fft_muscle_signal_task/num_samples_task);
fft_muscle_signal_task = fft_muscle_signal_task(1:num_samples_task/2+1);
fft_muscle_signal_task(2:end-1) = 2 * fft_muscle_signal_task(2:end-1);

% Finding and plotting FFT for baseline signal
f_baseline = fs * (0:(num_samples_baseline/2))/num_samples_baseline;
fft_muscle_signal_baseline = fft(muscle_signal_filtered_baseline);
fft_muscle_signal_baseline = abs(fft_muscle_signal_baseline/num_samples_baseline);
fft_muscle_signal_baseline = fft_muscle_signal_baseline(1:num_samples_baseline/2+1);
fft_muscle_signal_baseline(2:end-1) = 2 * fft_muscle_signal_baseline(2:end-1);

% Plot FFTs for task and baseline signals
figure;

ax = subplot(2, 1, 1);
plot(f_task, fft_muscle_signal_task);
title('Task Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
set(ax,'YLim',[0 0.01]);

ax = subplot(2, 1, 2);
plot(f_baseline, fft_muscle_signal_baseline);
title('Baseline Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
set(ax,'YLim',[0 0.01]);

% % Plot filtered task and baseline signals side by side
% figure;
% 
% subplot(2, 1, 1);
% plot(time_task, muscle_signal_filtered_task);
% title('Rectified Task Signal');
% xlabel('Time (s)');
% ylabel('Amplitude (mV)');
% 
% subplot(2, 1, 2);
% plot(time_baseline, muscle_signal_filtered_baseline);
% title('Rectified Baseline Signal');
% xlabel('Time (s)');
% ylabel('Amplitude (mV)');
% 
% % Calculate MAV and RMS for task signal
% mav_task = mean(abs(muscle_signal_filtered_task));
% rms_task = rms(muscle_signal_filtered_task);
% 
% % Calculate MAV and RMS for baseline signal
% mav_baseline = mean(abs(muscle_signal_filtered_baseline));
% rms_baseline = rms(muscle_signal_filtered_baseline);
% 
% fprintf('MAV Task: %f\n', mav_task);
% fprintf('RMS Task: %f\n', rms_task);
% 
% fprintf('MAV Baseline: %f\n', mav_baseline);
% fprintf('RMS Baseline: %f\n', rms_baseline);