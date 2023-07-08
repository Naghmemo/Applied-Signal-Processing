x = data(:,2,28);    % example vector % should translate data to the frequency domain

fs = 500;               % Sampling frequency
% omega_s = fs * 2 * pi;  % Angular frequency
Ndtft = 5000;           % Sampling Length
w=1;                    % Window Function

fbpm(x,fs)