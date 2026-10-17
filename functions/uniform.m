function r = uniform(a,b,s)
% function r = uniform(a,b,s)
%
% generate random numbers uniformly sampled between a and b, separated by step

r = random('uniform',a,b);

if exist('s')
    ss = a:s:b;
    r = ss(randi(length(ss)));
end
    