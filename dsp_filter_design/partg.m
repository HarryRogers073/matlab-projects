%===============================================================================
% File:         partg.m
% Written by:   Harry Rogers
% Date:         January 2026
% Description:  1st-order 16-bit Q15 fixed-point integer coefficient verification (200 Hz cutoff)
%===============================================================================

fs = 44100; % Sampling Frequency
fc = 200;   % Cutoff Frequency

% 1. Final Hardware Integer Coefficients (Q15)
% b0 = 461, b1 = 461, a1 = -31847
scale = 2^15; % 32768
b_int = [461, 461];
a_int = [32768, -31847]; % a0 is always the scale factor (1.0 in Q15)

% 2. Convert Integers back to Normalized Fractions for Analysis
b_q = b_int / scale;
a_q = a_int / scale;

% 3. Calculate Frequency Response (1024 points)
[h, f] = freqz(b_q, a_q, 1024, fs);
magnitude = 20*log10(abs(h));
phase = unwrap(angle(h)) * (180/pi); % Convert to degrees

% 4. Plotting Results
figure('Color', [1 1 1], 'Position', [100, 100, 800, 600]);

% Subplot 1: Amplitude Response
subplot(2,1,1);
semilogx(f, magnitude, 'b', 'LineWidth', 2);
grid on;
title('Amplitude (Magnitude) Response: 1st-Order 16-bit IIR');
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
axis([20 20000 -40 5]);
line([fc fc], [-40 5], 'Color', 'r', 'LineStyle', '--'); % Cutoff line
text(fc+10, -10, ' Cutoff (200Hz)', 'Color', 'r');

% Subplot 2: Phase Response
subplot(2,1,2);
semilogx(f, phase, 'g', 'LineWidth', 2);
grid on;
title('Phase Response: 1st-Order 16-bit IIR');
ylabel('Phase (degrees)');
xlabel('Frequency (Hz)');
axis([20 20000 -100 0]);

% Stability check output to console
fprintf('Stability Check (Max Pole Magnitude): %.4f\n', max(abs(roots(a_q))));