%===============================================================================
% Script:       Part_h.m
% Description:  4th-order Butterworth low-pass filter design with biquad second-order section (SOS) decomposition
% Author:       Harry Rogers (University of Brighton)
% Module:       EO626 - Digital Signal Processing
% Date:         2026
%===============================================================================

% Filter Design Parameters
Fs = 44100;      % CD Quality Sampling Rate
Fc = 200;        % Cutoff frequency for Bass
Order = 4;       % 4th order (2 biquad sections)

% Design the Butterworth Filter
[z, p, k] = butter(Order, Fc/(Fs/2), 'low');
[sos, g] = zp2sos(z, p, k);

% Display Coefficients for the Report
disp('--- Biquad Coefficients (Second-Order Sections) ---');
for i = 1:size(sos, 1)
    fprintf('Section %d Numerator (b): [%.6f, %.6f, %.6f]\n', i, sos(i,1), sos(i,2), sos(i,3));
    fprintf('Section %d Denominator (a): [%.6f, %.6f, %.6f]\n', i, sos(i,4), sos(i,5), sos(i,6));
end
fprintf('Total Gain (k): %.10f\n', g);

% Frequency Response Plot
freqz(sos, 1024, Fs);
title('Frequency Response: 200Hz Low-Pass Music Filter');
