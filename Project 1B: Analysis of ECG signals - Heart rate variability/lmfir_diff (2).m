function [h,R] = lmfir_diff(bfun,fpfun,p,M,m0,w)
% Fir filter design based on local models
%
% bfun = a function handle the basis function used
%         where bfun(i,m) should evaluate to the value for basis function index i and function argument m 
% fpfun = a function handle the derivative of the basis function used
%         where fpfun(i,m) should evaluate to the derivative (w.r.t m) for basis function index i and function argument m 
%     p = number of basis functions (indexed from 0 to p-1)
%     M = Window size. The designed filter will be of length 2M+1
%     m0 = index of desired predicted value. For m0=0 the filter will provide symmetric smoothing if $m0=M$ the
%         filter will provide the causal filtering output, i.e. sammple output is the estimate of the signal at the last 
%         sample.       
%     w = vector with positive weights for the associated LS problem

if nargin<6
    w = ones(2*M+1,1);
end

% Build R
R = zeros(2*M+1,p);
f = zeros(p,1);
for nidx=1:p
    for k=1:(2*M+1)
        R(k,nidx) = bfun(nidx-1, (k-M-1));
    end
    f(nidx) = fpfun(nidx-1,m0);
end

% h = f'*inv(R'*diag(w)*R)*R'*diag(w);
h = f'*((R'*diag(w)*R)\R'*diag(w));
h = h(end:-1:1);

