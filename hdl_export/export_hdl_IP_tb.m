%===============================================================================
% File:         export_hdl_IP_tb.m
% Written by:   Generated via MATLAB HDL Coder (Harness by Harry Rogers)
% Date:         January 2026
% Description:  Automated testbench for verifying exported synthesizable HDL filter core
%===============================================================================

numSamples = 200;
x = randn(numSamples,1);
testbench.data = fi(x,1,16,15);
data = testbench.data ;
NumDim = length(size( data ));
NumSamples = size( data ,1);
SamplesPerFrame = 1;
NumChannels = size( data ,2);
valid = true(1,NumSamples);
dataIn = data;
validIn = valid;

% call DUT with stimulus and save output
for ii =  1 :1:NumSamples
    [dataOut(ii), validOut(ii)] = export_hdl_IP(dataIn(ii), validIn(ii));
end

