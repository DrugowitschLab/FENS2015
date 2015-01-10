function discrete_obs(N, sig2)
%% plots evidence accumulation for N discrete observations
%
% The observations are drawn from the density
% p(x | z) = N(x | z, sig2),
% with z=1. Evidence is accumulated to differentiate between z = 1 and z =
% -1.
%
% The function plots the individual observations x1, x2, ..., the
% sufficient statistics X1, X2, ..., and the posterior belief p(z = 1 |
% x1:n), after each additional observation.
%
% N determines the number of observations, and sig2 the task difficulty
% (small/large sig2 = easy/hard task). If not given, N defaults to 10 and
% sig2 to 1.5^2.

%% settings
% number of observations
if nargin < 1, N = 10; end
% task difficulty (small/large sig2 = easy/hard task)
if nargin < 2, sig2 = 1.5^2; end
% plot colors for z=1 / z=-1
z1col = [0.3 0.67 0.77];
zm1col = [0.97 0.59 0.27];


%% draw observations and compute suff. stats and posterior
xs = 1 + sqrt(sig2) * randn(1, N); % draws from N(1, sig2)
Xs = [0 cumsum(xs)];
% p(z=1 | x)
pz1gx = 1 ./ (1 + exp(-2 * Xs / sig2));


%% plot observations, suff. stats, and posterior
figure('Color', 'white');

% observations
subplot(3, 1, 1);  hold on;
xlim([0 N]);  ylim([-1 1] * 3 * sqrt(sig2));
% plot xs > 0 and xs <= 0 in different colors
Ns = 1:N;
pos_xs = xs > 0;
if any(pos_xs)
    plot(Ns(pos_xs), xs(pos_xs), 'o', 'MarkerSize', 6, ...
         'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', z1col);
end
if any(~pos_xs)
    plot(Ns(~pos_xs), xs(~pos_xs), 'o', 'MarkerSize', 6, ...
         'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', zm1col);
end
ylims = ylim;
% likelihoods
xs = linspace(ylims(1), ylims(2), 100);
plot(exp(- (xs - 1).^2 / (2 * sig2)), xs, 'LineWidth', 2, 'Color', z1col);
plot(exp(- (xs + 1).^2 / (2 * sig2)), xs, 'LineWidth', 2, 'Color', zm1col);
% guides
plot(xlim, [0 0], 'k--', 'LineWidth', 1);
% labels
ylabel('x_n');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',1:N);

% sufficient statistic
subplot(3, 1, 2);  hold on;
xlim([0 N]);
% plot lines and markers separately, to specify marker colors
plot(0:N, Xs, 'k-', 'LineWidth', 3);
plot(0:N, Xs, 'o', 'MarkerSize', 6, ...
     'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', [0 0 0]);
% guides
plot(xlim, [0 0], 'k--', 'LineWidth', 1);
% labels
ylabel('X_n');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',1:N);

% posterior belief
subplot(3, 1, 3);  hold on;
xlim([0 N]);  ylim([0 1]);
% plot lines and markers separately, to specify marker colors
plot(0:N, pz1gx, 'k-', 'LineWidth', 3);
plot(0:N, pz1gx, 'o', 'MarkerSize', 6, ...
     'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', [0 0 0]);
% guides
plot(xlim, [0.5 0.5], 'k--', 'LineWidth', 1);
% labels
ylabel('p(z = 1| x_{1:n})');
xlabel('observation n');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',1:N);
