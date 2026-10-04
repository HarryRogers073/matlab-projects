%===============================================================================
% File:         Combined.m
% Written by:   Harry Rogers
% Date:         January 2026
% Description:  Frequency response analysis comparing Butterworth (IIR) and Hamming (FIR) filters
%===============================================================================

Fs = 44100;
Nfft = 16384; 

% 1. Load objects from your functions
Hb = Butterworth(); 
Hh = Hamming();     

% 2. Extract Complex Frequency Responses
[Hb_f, f] = freqz(Hb, Nfft, Fs); 
[Hh_f, ~] = freqz(Hh, Nfft, Fs);

% 3. Calculate Combined Vector Sum (Part g)
Hsum_f = Hb_f + Hh_f; 

% 4. Visualization with High Visibility
figure('Color', 'w', 'Name', 'Combined Spectra - High Visibility');

% --- SUBPLOT 1: Cartesian 4-Quadrant Map ---
subplot(2,2,1);
plot(real(Hb_f), imag(Hb_f), 'r--', 'LineWidth', 1.5); hold on;
plot(real(Hh_f), imag(Hh_f), 'g--', 'LineWidth', 1.5);
plot(real(Hsum_f), imag(Hsum_f), 'b', 'LineWidth', 2.5); % Combined (Thick)
grid on; axis equal;
title('Cartesian: Real vs Imaginary');
legend('Woofer (IIR)', 'Tweeter (FIR)', 'Combined');
xlabel('Real (In-Phase)'); ylabel('Imaginary (Quadrature)');

% --- SUBPLOT 2: Polar Plot ---
subplot(2,2,2);
polarplot(angle(Hb_f), abs(Hb_f), 'r--', 'LineWidth', 1.5); hold on;
polarplot(angle(Hh_f), abs(Hh_f), 'g--', 'LineWidth', 1.5);
polarplot(angle(Hsum_f), abs(Hsum_f), 'b', 'LineWidth', 2.5); % Combined (Thick)
title('Polar: Magnitude vs Phase');

% --- SUBPLOT 3: Magnitude (dB) ---
subplot(2,1,2); % Wider plot for clarity
semilogx(f, 20*log10(abs(Hb_f)+eps), 'r--', 'LineWidth', 1.5); hold on;
semilogx(f, 20*log10(abs(Hh_f)+eps), 'g--', 'LineWidth', 1.5);
semilogx(f, 20*log10(abs(Hsum_f)+eps), 'b', 'LineWidth', 2.5); % Combined (Thick)
grid on; xlim([20 20000]); ylim([-60 10]);
title('Magnitude Response Comparison');
ylabel('Magnitude (dB)'); xlabel('Frequency (Hz)');
legend('Woofer', 'Tweeter', 'Combined');