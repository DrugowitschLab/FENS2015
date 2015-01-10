function [Vd, Ve] = valueiteration(gs, dt, sig2, c)
%% performs value iteration and returns resulting value functions
%
% gs is the discretised belief (row) vector, dt is the time-steps for the
% belief transition density, sig2 is the variance of the momentary
% evidence, and c is the accumulation cost per unit time.
%
% The returned Vd is the value function associated with immediate
% decisions, max(g, 1-g), and Ve is the value function associated with
% continuing to accumulate more evidence. Their intersection determines the
% bound at which it is best to stop accumulating evidence.

%% value function for immediate decisions
Vd = max(gs, 1-gs);


%% belief transition densities
gg = belieftrans(gs, dt, sig2);


%% perform value iteration, starting at Vd
V = Vd;
while true
    % V * gg' results in the expected future value
    Ve = V * gg' - c * dt;
    % update value function and return if change below tolerance
    Vprev = V;
    V = max(Vd, Ve);
    if max(abs(Vprev - V)) < 1e-3 * dt, break; end
end