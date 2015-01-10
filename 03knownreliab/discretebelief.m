function [gs, dg] = discretebelief(g_num)
%% returns a row vector gs of discretised beliefs
%
% The beliefs are evenly discretised in steps of 1/g_num, while skipping 0
% and 1.
%
% The returned dg is the step size in which the beliefs are discretised.

dg = 1 / g_num;
gs = linspace(dg / 2, 1 - dg / 2, g_num);