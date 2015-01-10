function plot_diffusion_example(sig2, c, t)
%% function plots a trajectory in an example diffusion model
%
% sig2 specifies the task difficulty (variance of the prior over mu), c the
% cost for accumulating evdience, and t the time until when the optimal
% boundary is computed and the trajectory is simulated.
%
% The function computes the optimal decision boundary in belief before
% performing the diffusion model simulation.
%
% If not given, the arguments default to sig2 = 0.5^2, c = 0.1, and t = 3.

%% settings
% task difficulty
if nargin < 1, sig2 = 0.5^2; end;
% cost for accumulating evidence
if nargin < 2, c = 0.1; end;
% time-frame of interest
if nargin < 3, t = 3; end
% discretisation of belief and time (coarse, as only visualisation)
g_num = 100;
dt = 0.01;
N = ceil(t / dt);
t = N * dt;  % round up t to fit the discretisation
% time until which the value will be computed
T = 5 * t;


%% compute the value function
gs = discretebelief(g_num);
[Vd, Ve] = computevalues(gs, dt, T, sig2, c);


%% compute the resulting bounds in belief
g_bound = NaN(1, size(Ve, 1));
for i = 1:length(g_bound)
    g_bound(i) = valueintersect(gs, Vd, Ve(i,:));
end
% bound in x, mapping from g into x
ts = (0:(length(g_bound)-1)) * dt;
x_bound = sqrt(ts + 1/sig2) .* norminv(g_bound);


%% simulate trajectory (the slow way)
dtconst = sqrt(dt);
% draw trial difficulty
mu = abs(sqrt(sig2) * randn(1, 1));
% simulate trajectory until bounds
xs = 0;
for i = 2:N
    xs = cat(2, xs, xs(end) + mu * dt + dtconst * randn(1, 1));
    % stop simulation as soon as bound is reached
    if abs(xs(end)) > x_bound(i), break; end
end
% set end-point of trajectory to bound
xs(end) = x_bound(length(xs)) * sign(xs(end));
% trajectory in gs
ts = (0:(length(xs)-1)) * dt;
gs = normcdf(xs ./ sqrt(ts + 1/sig2));


%% plot trajectory in x and belief
ts = dt * (0:(N-1));
figure('Color', 'white');

% trajectory in x
subplot(1, 2, 1);  hold on;
xlim([0 max(ts)]);
% compute belief between bounds for each time-step, and plot
xs1 = linspace(-max(x_bound), max(x_bound), 100);
xg = ones(length(xs1), N);
for i = 1:N
    % indicies into xs1 between bounds
    bl = find(xs1 >= -x_bound(i), 1, 'first');
    bu = find(xs1 <= x_bound(i), 1, 'last');
    % compute belief within xs1(bl) and xs1(bu)
    xg(bl:bu, i) = normcdf(abs(xs1(bl:bu)) / sqrt(ts(i) + 1/sig2));
end
imagesc(ts, xs1, xg, [0.5, 1]);  colormap('bone');
% x trajectory
plot(ts(1:length(xs)), xs, 'LineWidth', 2, 'Color', [0.8 0 0]);
% bounds
plot(ts, x_bound(1:N), 'k', 'LineWidth', 3);
plot(ts, -x_bound(1:N), 'k', 'LineWidth', 3);
% labels
xlabel('time t');
ylabel('sufficient statistic X');
set(gca,'Layer','top','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02);

% trajectory in g
subplot(1, 2, 2);  hold on;
xlim([0 max(ts)]);  ylim([0 1]);
% fill belief between bounds for each time-step
gs1 = linspace(1-max(g_bound), max(g_bound), 100);
gg = ones(length(gs1), N);
for i = 1:N
    % indicies into gs1 between bounds
    bl = find(gs1 >= 1-g_bound(i), 1, 'first');
    bu = find(gs1 <= g_bound(i), 1, 'last');
    % fill belief within gs1(bl) and gs1(bu)
    gg(bl:bu, i) = max(gs1(bl:bu), 1-gs1(bl:bu));
end
imagesc(ts, gs1, gg, [0.5, 1]);  colormap('bone');
% belief trajectory
plot(ts(1:length(gs)), gs, 'LineWidth', 2, 'Color', [0.8 0 0]);
% bounds
plot(ts, g_bound(1:N), 'k', 'LineWidth', 3);
plot(ts, 1-g_bound(1:N), 'k', 'LineWidth', 3);
% labels
xlabel('time t');
ylabel('belief g');
set(gca,'Layer','top','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'YTick',0:0.5:1);
