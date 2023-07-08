%% QUESTION 5.

% SPECIFY DIFFERENT VALUES OF M
M = 20; % for different values of M, M = 1, 5, 10, 15, 50, 100, 200, 400

gain = 0.01; % NEW VALUE OF gain=0.01.
z = createdisturbance(N,gain);
x0 = data(:,1,1); %ECG trace
x = z + x0; %Add to the ECG trace
h = lmfir(@sincos,2,M,M); %create filter
zhat = filter(h,1,x); % Filter out disturbance
xhat = x-zhat;
plot(xhat) ; %the cleaned signal
hold on
plot(xhat-x0) % the remaining error
title(['Plot for M = ',num2str(M),' and gain = ',num2str(gain)])
legend('CleanedSignal','RemainingError')
norm(xhat(1000:end)-x0(1000:end))/sqrt(N-1000) % show the RMS error
% after filter transient