% Load task data
file_path_task = '/MATLAB Drive/Project_4_Task.mat';
load(file_path_task);
muscle_signal_task = data;

% Load baseline data
file_path_baseline = '/MATLAB Drive/Project_4_Baseline.mat';
load(file_path_baseline);
muscle_signal_baseline = data;

% Baseline correction for task signal
muscle_signal_baseline_task = mean(muscle_signal_task);
muscle_signal_task = muscle_signal_task - muscle_signal_baseline_task;

% Baseline correction for baseline signal
muscle_signal_baseline_baseline = mean(muscle_signal_baseline);
muscle_signal_baseline = muscle_signal_baseline - muscle_signal_baseline_baseline;

% Common parameters
fs = 1000;
num_samples_task = length(muscle_signal_task);
num_samples_baseline = length(muscle_signal_baseline);
time_task = (0:(num_samples_task - 1)) / fs;
time_baseline = (0:(num_samples_baseline - 1)) / fs;
f_task = fs * (0:(num_samples_task/2))/num_samples_task;
f_baseline = fs * (0:(num_samples_baseline/2))/num_samples_baseline;

% Bandpass filter for task signal
fcuthigh_task = 10;
fcutlow_task = 300;
[b_task, a_task] = butter(4, [fcuthigh_task, fcutlow_task]/(fs/2), 'bandpass');
muscle_signal_filtered_task = filtfilt(b_task, a_task, muscle_signal_task);

% Bandpass filter for baseline signal
fcuthigh_baseline = 10;
fcutlow_baseline = 100;
[b_baseline, a_baseline] = butter(4, [fcuthigh_baseline, fcutlow_baseline]/(fs/2), 'bandpass');
muscle_signal_filtered_baseline = filtfilt(b_baseline, a_baseline, muscle_signal_baseline);

% Zero-padding effect for task signal
figure;
zero_padding_factors = [10];
dominant_frequencies_task = zeros(size(zero_padding_factors));
dominant_frequencies_baseline = zeros(size(zero_padding_factors));

for i = 1:length(zero_padding_factors)
    zero_padding_factor = zero_padding_factors(i);
    fft_muscle_signal_padded_task = fft(muscle_signal_filtered_task, num_samples_task * zero_padding_factor);
    num_samples_task_new = length(fft_muscle_signal_padded_task);
    f_task = fs * (0:(num_samples_task_new/2))/num_samples_task_new;
    fft_muscle_signal_padded_task = abs(fft_muscle_signal_padded_task/num_samples_task_new);
    fft_muscle_signal_padded_task = fft_muscle_signal_padded_task(1:num_samples_task_new/2+1);
    fft_muscle_signal_padded_task(2:end-1) = 2*fft_muscle_signal_padded_task(2:end-1);

    % Identify the dominant frequency
    [~, idx_task] = max(fft_muscle_signal_padded_task);
    dominant_frequencies_task(i) = f_task(idx_task);

    hold on;
    plot(f_task, fft_muscle_signal_padded_task, 'DisplayName', ['Zero-Padding Factor = ' num2str(zero_padding_factor)]);
    xlim([0 300]);
end

title('Zero-Padded Filtered Task Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend;
grid on;

% Zero-padding effect for baseline signal
figure;

for i = 1:length(zero_padding_factors)
    zero_padding_factor = zero_padding_factors(i);
    fft_muscle_signal_padded_baseline = fft(muscle_signal_filtered_baseline, num_samples_baseline * zero_padding_factor);
    num_samples_baseline_new = length(fft_muscle_signal_padded_baseline);
    f_baseline = fs * (0:(num_samples_baseline_new/2))/num_samples_baseline_new;
    fft_muscle_signal_padded_baseline = abs(fft_muscle_signal_padded_baseline/num_samples_baseline_new);
    fft_muscle_signal_padded_baseline = fft_muscle_signal_padded_baseline(1:num_samples_baseline_new/2+1);
    fft_muscle_signal_padded_baseline(2:end-1) = 2*fft_muscle_signal_padded_baseline(2:end-1);

    % Identify the dominant frequency
    [~, idx_baseline] = max(fft_muscle_signal_padded_baseline);
    dominant_frequencies_baseline(i) = f_baseline(idx_baseline);

    hold on;
    plot(f_baseline, fft_muscle_signal_padded_baseline, 'DisplayName', ['Zero-Padding Factor = ' num2str(zero_padding_factor)]);
    xlim([0 100]);
end

title('Zero-Padded Filtered Baseline Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% Plot the change in dominant frequency for both task and baseline signals
figure;
plot(zero_padding_factors, dominant_frequencies_task, '-o', 'DisplayName', 'Task Signal');
hold on;
plot(zero_padding_factors, dominant_frequencies_baseline, '-o', 'DisplayName', 'Baseline Signal');
title('Change in Dominant Frequency with Zero-Padding Factor');
xlabel('Zero-Padding Factor');
ylabel('Dominant Frequency (Hz)');
legend;
grid on;

% Windowing Effect for task signal
figure;
subplot(2, 1, 1);
plot(time_task, muscle_signal_filtered_task);
title('Filtered Task Signal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

subplot(2, 1, 2);
window_types = {'rectangular', 'hamming', 'hanning'};
for i = 1:length(window_types)
    window_type = window_types{i};

    % Generate the window function
    window = windowFunction(window_type, num_samples_task);

    % Apply windowing to the signal
    muscle_signal_windowed_task = muscle_signal_filtered_task .* window;

    % Compute the Fourier Transform for windowed signal
    fft_muscle_signal_windowed_task = fft(muscle_signal_windowed_task);
    fft_muscle_signal_windowed_task = abs(fft_muscle_signal_windowed_task/num_samples_task);
    fft_muscle_signal_windowed_task = fft_muscle_signal_windowed_task(1:num_samples_task/2+1);
    fft_muscle_signal_windowed_task(2:end-1) = 2*fft_muscle_signal_windowed_task(2:end-1);

    hold on;
    plot(f_task, fft_muscle_signal_windowed_task, 'DisplayName', [window_type ' Window']);
end

title('Windowed Filtered Task Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend;
grid on;

% Windowing Effect for baseline signal
figure;
subplot(2, 1, 1);
plot(time_baseline, muscle_signal_filtered_baseline);
title('Filtered Baseline Signal');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

subplot(2, 1, 2);
for i = 1:length(window_types)
    window_type = window_types{i};

    % Generate the window function
    window = windowFunction(window_type, num_samples_baseline);

    % Apply windowing to the signal
    muscle_signal_windowed_baseline = muscle_signal_filtered_baseline .* window;

    % Compute the Fourier Transform for windowed signal
    fft_muscle_signal_windowed_baseline = fft(muscle_signal_windowed_baseline);
    fft_muscle_signal_windowed_baseline = abs(fft_muscle_signal_windowed_baseline/num_samples_baseline);
    fft_muscle_signal_windowed_baseline = fft_muscle_signal_windowed_baseline(1:num_samples_baseline/2+1);
    fft_muscle_signal_windowed_baseline(2:end-1) = 2*fft_muscle_signal_windowed_baseline(2:end-1);

    hold on;
    plot(f_baseline, fft_muscle_signal_windowed_baseline, 'DisplayName', [window_type ' Window']);
end

title('Windowed Filtered Baseline Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend;
grid on;

function window = windowFunction(window_type, N)
    % Generate window function
    switch window_type
        case 'rectangular'
            window = rectwin(N);
        case 'hamming'
            window = hamming(N);
        case 'hanning'
            window = hanning(N);
        otherwise
            error('Invalid window type.');
    end
end