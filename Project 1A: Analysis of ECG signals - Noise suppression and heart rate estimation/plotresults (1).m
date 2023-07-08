% This script plots the HR estimation results for all athletes

load('Data/ath.mat');
% load('Data/VisualHr.mat');
% close all

fs = 500;

% VISUAL INSPECTION OF GROUP 41
bpm_V=[60; 60; 54; 51; 48; 48; 66; 72; 54; 54; 66; 54; 39; 66; 54; 48; 72; 60; 66; 66; 48; 66; 48; 48; 54; 66; 48; 51]; % for athletes 1 to 28

% Determine sizes
[N,Nleads,Nath] = size(data);

% Vector of visually determined HR
%VisualHR = 58*ones(Nath,1); % (This is not the correct value!)

results = zeros(Nath,Nleads);
for ath = 1:Nath
    for lead = 1:Nleads
        %figure(2)
        results(ath,lead) = fbpm(data(:,lead,ath),fs);
    end
end

figure(1)
% Plot estimate for all leads and all athletes
plot(kron(ones(Nleads,1),(1:Nath)'),results(:),'+','MarkerSize',14)
hold on

% Plot the Visual heart rate
plot(1:Nath,bpm_V,'o','MarkerSize',14);
plot(1:Nath,mean(results'),'s','MarkerSize',14);

% plot(1:Nath,median(results'),'s','MarkerSize',14);
hold off

%RMS error for the median estimates over  all athletes
norm(VisualHr.'-median(results'))/sqrt(Nath)




