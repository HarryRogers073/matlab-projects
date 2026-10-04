%===============================================================================
% File:         filterOrderTests.m
% Written by:   Harry Rogers
% Date:         January 2026
% Description:  Empirical filter order testing and audio playback comparison harness
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
start_time = 2.5;                
duration  = 30;                
start_sample = floor(start_time * fs_target) + 1;
end_sample   = start_sample + duration * fs_target - 1;
x_final = x_resampled(start_sample:end_sample);

% 4. Save file (Using your name as per brief) 
audiowrite('Harry_Rogers_RAW_Music.wav', x_final, fs_target);
disp('Part A Complete: RAW file created.');

%% --- PART B & C: FILTER DESIGN AND APPLICATION ---
Fs = 44100;          
fc = 1800; % Mandated crossover frequency 
deltaF = 450; % Justified transition width 

% 1. FIR High-Pass Design (Hamming Window) 
N_Hamming = ceil(3.3 / (deltaF / Fs)); 
if mod(N_Hamming, 2) ~= 0, N_Hamming = N_Hamming + 1; end % Ensure Even Order/Odd Taps
h_fir = fir1(N_Hamming, fc/(Fs/2), 'high', hamming(N_Hamming+1));
y_fir = filter(h_fir, 1, x_final);
audiowrite('Harry_Rogers_FIR_Music.wav', y_fir, Fs);

% 2. IIR Low-Pass Design (4th-Order Butterworth) 
[b_iir, a_iir] = butter(4, fc/(Fs/2), 'low');
y_iir = filter(b_iir, a_iir, x_final);
audiowrite('Harry_Rogers_IIR_Music.wav', y_iir, Fs);

disp('Part B & C Complete: FIR and IIR files created.');

%% --- PART F & G: SIGNAL SUMMATION (COMB) ---
% Alignment: FIR filters introduce a group delay of N/2 samples. 
% To sum correctly, the IIR signal must be delayed to match. 
delay_samples = N_Hamming / 2;
y_iir_delayed = [zeros(delay_samples, 1); y_iir(1:end-delay_samples)];

% Combined Output (Far-field total sound spectrum) 
y_comb = y_fir + y_iir_delayed;
audiowrite('Harry_Rogers_COMB_Music.wav', y_comb, Fs);

disp('Part F Complete: COMB file created.');

%% --- SPECTRA VISUALIZATION (FOR REPORT PART E & G) ---
% FIR Spectra
figure('Name', 'FIR High-Pass Spectra');
subplot(2,1,1); freqz(h_fir, 1, 1024, Fs); title('FIR Magnitude and Phase');

% IIR Spectra
figure('Name', 'IIR Low-Pass Spectra');
subplot(2,1,1); freqz(b_iir, a_iir, 1024, Fs); title('IIR Magnitude and Phase');

% Combined Spectra 
figure('Name', 'Combined System Spectrum');
[H_comb, f] = freqz(y_comb, 1, 1024, Fs);
subplot(2,1,1); plot(f, 20*log10(abs(H_comb))); title('Combined Magnitude (dB)'); grid on;
subplot(2,1,2); plot(f, angle(H_comb)); title('Combined Phase (Radians)'); grid on;