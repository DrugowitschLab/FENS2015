function x = nondpbound(sig2, c)
%% finds the optimal bound by directly maximising the expected reward
%
% sig2 is the variance of the momentary evidence, and c is the accumulation
% cost per unit time.

% find bound that maximised expected reward
x = fminbnd(@(x) -expectedreward(x, sig2, c), 1e-30, 1e30);


function er = expectedreward(x, sig2, c)
%% returns the expected reward for the given bound height x

% probability correct and expected first-passage time
pc = 1 / (1 + exp(-2 * x / sig2));
rt = x * tanh(x / sig2);
% expected reward
er = pc - c * rt;