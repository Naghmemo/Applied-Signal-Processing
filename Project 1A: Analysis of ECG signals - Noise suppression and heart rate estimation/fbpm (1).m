function BPM = fbmp(x,fs)

% fs = 500;               % Sampling frequency
% omega_s = fs * 2 * pi;  % Angular frequency
Ndtft = 5000;           % Sampling Length
w=1;                    % Window Function

Xw = fft(w.*x,Ndtft); % DTFT of Xw(n)
Xabs = abs(Xw); % absolute value of Xw as a vector

omega = 2*pi*fs*(0:Ndtft-1)/Ndtft; % creating the x axis - frequency domain
plot(omega,Xabs)

omega_min = 35 * 2 * pi / 60 % corresponding to min BPM
omega_max = 200 * 2 * pi / 60 % corresponding to max BPM

Iset = find(omega>omega_min & omega<omega_max);       % finding the indices that correspond to omega_min_and_max
Xw_max_vector = [Xabs(Iset(1):(Iset(length(Iset))))]; % Finding X of omega
[mval,idx] = max(Xw_max_vector);                      % Finding X of omega

true_idx = (Iset(1)-1) + idx;                         % Finding global index

HR_k = 30 / pi * omega(true_idx); % corresponding heart rate

BPM = HR_k;





