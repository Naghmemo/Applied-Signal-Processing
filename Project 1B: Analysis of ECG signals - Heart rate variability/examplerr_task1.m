%% CLEAR WORKSPACE

clear
clc

dd = dir('data B/*.mat');   %list folder contents

%% INITIAL DEFINITIONS

M = 3;                  % window parameter(given)
m0 = M;                 % selection of m0 to have a causal filter
Nfiles = length(dd);    % Number of data sets
NN = 8000;              % Length of Data to analyze and plot
offset = 4000;          % Offset into the dataset to remove the initial samples
fs = 128;               % sampling frequency of the data
p1 = 3;                 % model order

%% SETTING positive weights for the associated LS problem

% w = lam.^(2*M:-1:0) with  0<lam<1;
w_method = zeros(2*M,1);

for i=1:2*M+1 
    w_method(i,1) = 0.5 ^ (2*M+1-i);  % for lam = 0.5 arbitrarily taken between 0 and 1
end

%% CODE CONTINUATION

for ff = 1:Nfiles
    load(['data B/',dd(ff).name]);
    x0 = data(offset+(1:NN),1);
    
    % Here is a lmfir_diff filter designed
    h1diff = lmfir_diff(@monofun,@monoderfun, p1, M, m0, w_method);
    y1diff = filter(h1diff,1,x0);
    
    % y1diff = x0;      % uncomment this if directly peak-find on ECG trace.
    figure(ff)
    plot([y1diff 0.1*x0])
    title(['EGC Plot for Data Set Number =',num2str(ff)])
    hold on

    % You need to set MPH and MPD to some good values.... <== How to
    % determine those values ?
    % ANSWER: For MPH we shall find the maximum peak from EGC
    % traces and will define a fraction between zero and one that is gonna
    % be our threshold for the MinPeakHeight.
    % For MinPeakDistance we should find an average distance from our
    % visual data between the min peaks P and T as illustrated in the
    % definition of the problem

    MPH = 0.3 * max(x0) % fraction = between 0 and 1

    MPD = 50; % by visually inspecting the actual signal
    
    [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD); %finding the Amplitude and Indices af the R peaks

    plot(r_indices,p,'hr')
    hold off
    
    % Calculate RR intervals

    rr = diff(r_indices);      % calculate IHR for each iteration

    figure(ff+4)
    plot(r_indices(1:end-1)/fs,(1./rr)*fs*60)
    title(['IHR for Data Set Number =',num2str(ff)])
    % pause
end 

function f = monofun(i,m) 
    if i==0
        f = 1;
    elseif i==1
        f = m;
    elseif i>0
        f = m^i;
    else
        error('i must be a positive integer');
    end
end

function fd = monoderfun(i,m) 
    if i==0
        fd = 0;
    elseif i==1
        fd = 1;
    elseif i>1
        fd = i*(m^(i-1));
    else
        error('i must be a positive integer');
    end
end
