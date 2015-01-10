function continuous_obs(t, sig2)
%% plots evidence accumulation for t seconds
%
% The momentary evidence is drawn in steps dt from the density
% p(dx | z) = N(x | z dt, sig2 dt),
% with z=1. Evidence is accumulated to differentiate between z = 1 and z =
% -1.
%
% The function plots the individual observations x1, x2, ..., the
% sufficient statistics X1, X2, ..., and the posterior belief p(z = 1 |
% x1:n), after each additional observation.
%
% t determines the accumulation time, and sig2 the task difficulty
% (small/large sig2 = easy/hard task). If not given, t defaults to 1 and
% sig2 to 1^2.

%% settings
% simulation step size
dt = 0.01;
% observation time
if nargin < 1, t = 1; end
% task difficulty (small/large sig2 = easy/hard task)
if nargin < 2, sig2 = 1^2; end
% plot colors for z=1 / z=-1
z1col = [0.3 0.67 0.77];
zm1col = [0.97 0.59 0.27];


%% discretise time
N = ceil(t / dt);
t = N * dt;
ts = 0:dt:(t-dt);


%% draw observations and compute suff. stats and posterior
dxs = dt + sqrt(sig2 * dt) * randn(1, N); % draws from N(dt, sig2 * dt)
Xs = cumsum(dxs);
% p(z=1 | x)
pz1gx = 1 ./ (1 + exp(-2 * Xs / sig2));


%% plot observations, suff. stats, and posterior
figure('Color', 'white');

% observations
subplot(3, 1, 1);  hold on;
xlim([0 t]);  ylim([-1 1] * 3 * sqrt(sig2));
% plot dxs > 0 and dxs <= 0 in different colors
pos_xs = dxs > 0;
if any(pos_xs)
    plot(ts(pos_xs), dxs(pos_xs) / dt, '+', 'MarkerSize', 3, ...
         'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', z1col);
end
if any(~pos_xs)
    plot(ts(~pos_xs), dxs(~pos_xs) / dt, '+', 'MarkerSize', 3, ...
         'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', zm1col);
end
ylims = ylim;
% likelihoods
dxs = linspace(ylims(1), ylims(2), 100);
plot(0.5 * exp(- (dxs - 1).^2 / (2 * sig2)), dxs, 'LineWidth', 2, 'Color', z1col);
plot(0.5 * exp(- (dxs + 1).^2 / (2 * sig2)), dxs, 'LineWidth', 2, 'Color', zm1col);
% guides
plot(xlim, [0 0], 'k--', 'LineWidth', 1);
% labels
ylabel('dx_n / dt');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:floor(t));

% sufficient statistic
subplot(3, 1, 2);  hold on;
xlim([0 t]);
plot(ts, Xs, 'k-', 'LineWidth', 2);
% guides
plot(xlim, [0 0], 'k--', 'LineWidth', 1);
% labels
ylabel('X(t)');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:floor(t));

% posterior belief
subplot(3, 1, 3);  hold on;
xlim([0 t]);  ylim([0 1]);
plot(ts, pz1gx, 'k-', 'LineWidth', 2);
% guides
plot(xlim, [0.5 0.5], 'k--', 'LineWidth', 1);
% labels
ylabel('p(z = 1| x_{0:t})');
xlabel('time t');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:floor(t));
