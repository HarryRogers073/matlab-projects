%===============================================================================
% File:         fileFormatting.m
% Written by:   Harry Rogers
% Date:         January 2026
% Description:  Audio sample pre-processing: stereo-to-mono downmix and 44.1 kHz resampling harness
%===============================================================================

filename = 'Redbone.wav'; 
[x, fs_original] = audioread(filename);

% 1. Convert to Mono (Average L/R)
x_mono = mean(x, 2);

% 2. Resample to 44,100 Hz
fs_target = 44100;
if fs_original ~= fs_target
    x_resampled = resample(x_mono, fs_target, fs_original);
else
    x_resampled = x_mono;
end

% 3. Extract 30 seconds from 2.5s to 32.5s
start_time = (60*4+45);                % seconds
duration  = 30;                % seconds
start_sample = floor(start_time * fs_target) + 1;
end_sample   = start_sample + duration * fs_target - 1;

x_final = x_resampled(start_sample:end_sample);

% 4. Save file
audiowrite('Harry_Rogers_RAW_Music.wav', x_final, fs_target);
disp('Part A Complete: RAW file created.');

%% FIR HighPass Hamming Filter 

% Finding the Filter Order

% 1. Define Parameters
Fs = 44100;          % Sampling Frequency (Hz)
deltaF = 450;       % Transition Width (Hz)

% 2. Calculate Normalized Transition Width (Delta Omega)
deltaOmega = (pi * deltaF) / Fs;

% 3. Calculate Filter Order (N)
N_Hamming = round((3.3 * pi) / deltaOmega) + 1;

% 4. Display Result
disp(['Required Hamming Filter Order: ', num2str(N_Hamming)]);

% Load generated files
% [iir_audio, Fs] = audioread('Harry_Rogers_IIR_Music.wav');
% [fir_audio, Fs] = audioread('Harry_Rogers_FIR_Music.wav');
% 
% % Plot the Spectra Comparison
% figure('Name', 'Woofer vs Tweeter Check');
% 
% % Woofer Plot (Blue)
% subplot(2,1,1);
% pwelch(iir_audio, [], [], [], fs);
% title('Woofer Output (Low Pass) - Should drop off after 1.8 kHz');
% xline(1800, 'r--', 'Crossover 1.8k'); % Add a red line at cutoff
% 
% % Tweeter Plot (Green)
% subplot(2,1,2);
% pwelch(fir_audio, [], [], [], fs);
% title('Tweeter Output (High Pass) - Should rise up at 1.8 kHz');
% xline(1800, 'r--', 'Crossover 1.8k');
% 
% % Read files
% [y_low, fs] = audioread('Harry_Rogers_IIR_Music.wav');
% [y_high, ~] = audioread('Harry_Rogers_FIR_Music.wav');
% 
% % Align Signals
% % FIR Delay = Order/2 = 1456/2 = 728 samples
% delay = 728;
% % Pad the IIR signal with zeros at the start to match FIR delay
% y_low_delayed = [zeros(delay,1); y_low(1:end-delay)];
% 
% % Summation
% len = min(length(y_low_delayed), length(y_high));
% y_comb = y_low_delayed(1:len) + y_high(1:len);
% 
% audiowrite('Harry_Rogers_COMB_Music.wav', y_comb, fs);
% disp('Part F Complete: Signals Combined.');