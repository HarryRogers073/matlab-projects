%===============================================================================
% Script:       test_widths.m
% Description:  Transition bandwidth parameter sweep script analyzing required FIR filter orders
% Author:       Harry Rogers (University of Brighton)
% Module:       EO626 - Digital Signal Processing
% Date:         2026
%===============================================================================

Fs = 44100;
fc = 1800;
test_width = 50:50:1800; % Test different widths from 50 to 1800 Hz in increments of 50

% Initialize arrays to store transition widths and filter orders
transition_widths = [];
filter_orders = [];

for df = test_width
    % Calculate order and ensure it is even 
    deltaOmega = (pi * df) / Fs; % Calculate Normalized Transition Width (Delta Omega)
    N = round((3.3 * pi )/ deltaOmega); % Calculate filter order based on deltaOmega
    if mod(N, 2) ~= 0, N = N + 1; end % If order number isn't even add one to make it even
    
    % Store transition width and filter order
    transition_widths = [transition_widths; df];
    filter_orders = [filter_orders; N];
    
    % Generate filter 
    h = fir1(N, fc/(Fs/2), 'high', hamming(N+1));
    
    % Visualise different filters
    figure('Name', ['Transition Width: ', num2str(df), ' Hz']);
    freqz(h, 1, 1024, Fs); 
    title(['Magnitude and Phase for DeltaF = ', num2str(df)]);
end

% Display tabulation of transition widths and filter orders
disp('Transition Width (Hz)    Filter Order');
disp([transition_widths, filter_orders]);