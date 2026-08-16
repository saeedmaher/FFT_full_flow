clear; close all

T = data_types_FFT('double');

% Desgin parameters
P = 16; % FFT points
Nrandom = 1000; % Number of randomized signals
x_double = zeros(1,P); % signal vactor

% Random signals 
for i = 1: Nrandom
    rng(i);

    % I/P
    x_double = randn(1,P) + 1i*randn(1,P);
    x = cast(x_double, 'like', T.x);
    
    % O/P
    out = cast(DIF_FFT_mex(x,T), 'like', T.y);

    % Golden reference
    out_exp = fft(x_double);

    % Error and SQNR
    error(i) = max(abs(out - out_exp));
    sqnr(i) = 10*log10(sum(abs(out_exp).^2)/sum(abs(double(out) - out_exp).^2) );
end

%% saving data

%save("double_results.mat","sqnr","error");
%save("fixed_16_results.mat","sqnr","error");
save("fixed_12_results.mat","sqnr","error");

