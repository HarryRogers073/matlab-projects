%===============================================================================
% Script:       New_Combined.m
% Description:  Final coursework report 4-subplot visualization script for woofer, tweeter, and combined loudspeaker responses
% Author:       Harry Rogers (University of Brighton)
% Module:       EO626 - Digital Signal Processing
% Date:         2026
%===============================================================================

%% EO626: Final Report Visualisation Script
% 4 Figures, each containing 4 subplots: Individual, Combined, and Comparison.
% Colours: Woofer=Red, Tweeter=Green, Combined=Orange.

clear; clc; close all;

% --- 1. Parameters & Data Acquisition ---
Fs = 44100;
Nfft = 2^16; 

% Load filter objects from your function files
Hb_obj = Butterworth(); 
Hh_obj = Hamming();     

% Generate complex frequency response vectors
[Hb_f, f] = freqz(Hb_obj, Nfft, Fs); 
[Hh_f, ~] = freqz(Hh_obj, Nfft, Fs);

% Complex vector sum for the acoustic reconstruction
Hsum_f = Hb_f + Hh_f; 

% Define colour palette for consistency
colIIR = [0.8 0 0];    % Deep Red
colFIR = [0 0.5 0];    % Forest Green
colSum = [1 0.5 0];    % Bright Orange

% --- PAGE 1: MAGNITUDE ANALYSIS (dB) ---
figure('Color', 'w', 'Name', 'Page 1 - Magnitude Response');
subplot(2,2,1); plot_mag(f, Hb_f, colIIR, 'Woofer (IIR) Magnitude');
subplot(2,2,2); plot_mag(f, Hh_f, colFIR, 'Tweeter (FIR) Magnitude');
subplot(2,2,3); plot_mag(f, Hsum_f, colSum, 'Combined Result Only');
subplot(2,2,4); 
    plot_mag(f, Hb_f, colIIR, 'Comparison Overlay'); hold on;
    plot_mag(f, Hh_f, colFIR, '');
    plot_mag(f, Hsum_f, colSum, '');
    legend('Woofer', 'Tweeter', 'Combined', 'Location', 'southwest');

% --- PAGE 2: PHASE ANALYSIS (RAD) ---
figure('Color', 'w', 'Name', 'Page 2 - Phase Response');
subplot(2,2,1); plot_phase(f, Hb_f, colIIR, 'Woofer (IIR) Phase');
subplot(2,2,2); plot_phase(f, Hh_f, colFIR, 'Tweeter (FIR) Phase');
subplot(2,2,3); plot_phase(f, Hsum_f, colSum, 'Combined Result Only');
subplot(2,2,4); 
    plot_phase(f, Hb_f, colIIR, 'Comparison Overlay'); hold on;
    plot_phase(f, Hh_f, colFIR, '');
    plot_phase(f, Hsum_f, colSum, '');
    legend('Woofer', 'Tweeter', 'Combined');

% --- PAGE 3: CARTESIAN ANALYSIS (REAL/IMAG) ---
figure('Color', 'w', 'Name', 'Page 3 - Cartesian Mapping');
subplot(2,2,1); plot_cart(Hb_f, colIIR, 'Woofer (IIR) Cartesian');
subplot(2,2,2); plot_cart(Hh_f, colFIR, 'Tweeter (FIR) Cartesian');
subplot(2,2,3); plot_cart(Hsum_f, colSum, 'Combined Result Only');
subplot(2,2,4); 
    plot_cart(Hb_f, colIIR, 'Comparison Overlay'); hold on;
    plot_cart(Hh_f, colFIR, '');
    plot_cart(Hsum_f, colSum, '');
    legend('Woofer', 'Tweeter', 'Combined');

% --- PAGE 4: POLAR REPRESENTATION ---
figure('Color', 'w', 'Name', 'Page 4 - Polar Mapping');
subplot(2,2,1); plot_polar(Hb_f, colIIR, 'Woofer (IIR) Polar');
subplot(2,2,2); plot_polar(Hh_f, colFIR, 'Tweeter (FIR) Polar');
subplot(2,2,3); plot_polar(Hsum_f, colSum, 'Combined Result Only');
subplot(2,2,4); 
    plot_polar(Hb_f, colIIR, 'Comparison Overlay'); hold on;
    plot_polar(Hh_f, colFIR, '');
    plot_polar(Hsum_f, colSum, '');
    legend('Woofer', 'Tweeter', 'Combined');

%% --- Plotting Helper Functions ---

function plot_mag(f, H, col, titl)
    semilogx(f, 20*log10(abs(H)+eps), 'Color', col, 'LineWidth', 1.5);
    grid on; xlim([20 20000]); ylim([-80 15]);
    ylabel('Gain (dB)'); xlabel('Frequency (Hz)'); title(titl);
end

function plot_phase(f, H, col, titl)
    plot(f, unwrap(angle(H)), 'Color', col, 'LineWidth', 1.5);
    grid on; xlim([0 5000]); 
    ylabel('Phase (rad)'); xlabel('Frequency (Hz)'); title(titl);
end

function plot_cart(H, col, titl)
    plot(real(H), imag(H), 'Color', col, 'LineWidth', 1.5);
    grid on; axis equal; xlim([-1.5 2.5]); ylim([-2 2]);
    xlabel('Real Part'); ylabel('Imaginary Part'); title(titl);
end

function plot_polar(H, col, titl)
    polarplot(angle(H), abs(H), 'Color', col, 'LineWidth', 1.5);
    title(titl);
end