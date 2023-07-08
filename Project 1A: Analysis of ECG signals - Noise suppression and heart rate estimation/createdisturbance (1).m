function z = createdisturbance(N,gain)

if nargin < 2
    gain=0.001;
end

f = 50/500;

nidx = (1:N)';

avec = cumsum([1; gain*randn(N-1,1);]);
bvec = cumsum([1; gain*randn(N-1,1);]);

z = avec.*cos(2*pi*f*nidx) + bvec.*sin(2*pi*f*nidx);