%% 1. CREATE A DISTURBANCE
z0 = createdisturbance(5000,0); % creates a disturbance for N = 5000 samples and gain = 0
xECG_0 = data(:,4,12) + z0; % add disturbance to one of the traces

plot(xECG_0) % plot resutling signal which is really hard to interpret

%% 3. The following commands illustrate the use of the technique

% SPECIFY DIFFERENT VALUES OF M
M = 10; % for M = 1, 5, 10, 15, 50, 100, 200, 400

gain = 0;
z = createdisturbance(N,gain);
x0 = data(:,1,1); %ECG trace
x = z + x0; %Add to the ECG trace
h = lmfir(@sincos,2,M,M); %create filter
zhat = filter(h,1,x); % Filter out disturbance
xhat = x-zhat;
plot(xhat) ; %the cleaned signal
% hold on
% plot(xhat-x0) % the remaining error
% title(['Plot for M = ',num2str(M)])
legend('CleanedSignal','RemainingError')
norm(xhat(1000:end)-x0(1000:end))/sqrt(N-1000) % show the RMS error
% efter filter transient