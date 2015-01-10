function plot_diffusion_example(sig2, g_bound)
%% function plots a trajectory in an example diffusion model
%
% sig2 specifies the task difficulty (variance of the prior over mu), and
% g_bound the height of the bound (>0.5, <1) in the decision maker's
% belief.
%
% If not given, the arguments default to sig2 = 2, and g_bound = 0.95.

%% settings
% variance of momentary evidence
if nargin < 1, sig2 = 2; end
% bound in belief
if nargin < 2, g_bound = 0.95; end
% simulation time-steps
dt = 0.001;


%% map bound into x-space
x_bound = sig2 * log(g_bound / (1 - g_bound)) / 2;


%% simulate trajectory
% this is the slow way of simulating the model, as I extend the xs array as
% I go along. Pre-allocating the array would be faster, but here, speed is
% not an issue.
xs = 0;
sigconst = sqrt(sig2 * dt);
while true
    xs = cat(2, xs, xs(end) + dt + sigconst * randn(1, 1));
    % stop simulation when boundary has been crossed
    if abs(xs(end)) > x_bound, break; end
end
% correct last x to be at rather than past boundary
xs(end) = sign(xs(end)) * x_bound;
% map into g
gs = 1 ./ (1 + exp(- 2 * xs / sig2));


%% plot trajectory in x and belief
figure('Color', 'white');
N = length(xs);
T = ceil(N * dt);
ts = 0:dt:T;

% trajector in x
subplot(1, 2, 1);  hold on;
xlim([0 max(ts)]);
% shaded belief area behind x trajectory
xs1 = linspace(-x_bound, x_bound, 100);
gs1 = 1 ./ (1 + exp(- 2 * xs1 / sig2));
imagesc(ts,xs1,repmat(max(gs1,1-gs1)',1,length(ts)),[0.5 1]);  colormap('bone');
% x trajectory
plot(ts(1:N), xs, 'LineWidth', 2, 'Color', [0.8 0 0]);
% bounds
plot(xlim, [1 1] * x_bound, 'k', 'LineWidth', 3);
plot(xlim, [1 1] * (-x_bound), 'k', 'LineWidth', 3);
% labels
xlabel('time t');
ylabel('sufficient statistcs X');
set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:T);

% trajector in belief
subplot(1, 2, 2);  hold on;
xlim([0 max(ts)]);  ylim([0 1]);
% shaded belief area behind belief trajectory
gs1 = linspace(1-g_bound, g_bound, 100);
imagesc(ts,gs1,repmat(max(gs1,1-gs1)',1,length(ts)),[0.5 1]);  colormap('bone');
% belief trajectory
plot(ts(1:N), gs, 'LineWidth', 2, 'Color', [0.8 0 0]);
% bounds
plot(xlim, [1 1] * g_bound, 'k', 'LineWidth', 3);
plot(xlim, [1 1] * (1-g_bound), 'k', 'LineWidth', 3);
% labels
xlabel('time t');
ylabel('belief g');
set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:T,'YTick',0:0.5:1);

