%% CLEAR WORKSPACE
clear
clc

%% INITIAL DEFINITIONS
ff=2;  %specify the number of data set, 1,2,3,4
M = 3; % window parameter
m0 = M; % selection of a causal filter
dd = dir('data B/*.mat');
Nfiles = length(dd);
offset = 4000; % Offset into the dataset
fs = 128; % sampling frequency
p1 = 3; % model order

%% SETTING positive weights for the associated LS problem
w_method = zeros(2*M,1);

for i=1:2*M+1 % for lam = 0.5 arbitrarily taken between 0 and 1
    w_method(i,1) = 0.5 ^ (2*M+1-i);
end

%% CODE CONTINUATION

load(['data B/',dd(ff).name]);
x0 = data(offset+(1:end-offset),1);        % put the whole data in a vector and remove the first 4000 samples(offset)
minute=0;
S_per_minute=60*fs;                        %number of Samples per Minute with respect to sampling frequency
N_minute=floor(length(x0)/S_per_minute);   % Number of Minutes for the whole data set
mean_rr=zeros(N_minute,1);                 %creating a vector same as the size of the number of the minutes for average of RR
std_rr=zeros(N_minute,1);                  %creating a vector same as the size of the number of the minutes for standard deviation
for k=0:N_minute-1
    minute=minute+1;                       %for vector index
    A_k=x0((1+(k*S_per_minute)):(((k+1)*S_per_minute))); %divide the data to one minute segments
    MPH = 0.35;                    % fraction = 0.1 between 0 and 1
    MPD = 50;                                % by visually inspecting the actual signal
    h1diff = lmfir_diff(@monofun,@monoderfun, p1, M, m0, w_method);
    A_k_diff = filter(h1diff,1,A_k);
    [p,r_indices] = findpeaks(A_k_diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD);  %detect the peaks in the segments
    rr = diff(r_indices);                    % calculate rr intervals for each iteration
    mean_rr(minute)=mean(rr);                %calculate the average of the rr vecor which contains the rr intervals of this segment and put it as the element in mean_rr vector
    std_rr(minute)=std(rr);                  %calculate the standard deviation of the rr vecor which contains the rr intervals of this segment and put it as the element in S_deviation vector
end
figure(1)
plot(mean_rr)
title(['Average of RR interval for data set Number',num2str(ff)])
xlabel('Time (minute)') 
ylabel('Average of RR intervals') 
figure(2)
plot(std_rr)
title(['Standard deviation for data set number',num2str(ff)])
xlabel('Time (minute)') 
ylabel('Standard Deviation')

    
   



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
