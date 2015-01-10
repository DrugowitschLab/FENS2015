function plot_valuefn(sig2, c, t)
%% plots an example of a value function and the associated bound
%
% sig2 is the overall task difficulty (variance of prior on mu), c is the
% evidence accumulation cost, and t is the time until which the values are
% to be computed. The function computes until 5*t that time, but only
% displays the value function / bounds until t.
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
t = ceil(t / dt) * dt;  % round up t to fit the discretisation
% time until which the value will be computed
T = 5 * t;
% colors
cut_cols = [zeros(3, 2) linspace(0.4, 0.8, 3)'];
bound_cols = [zeros(3, 1) linspace(0.4, 0.8, 3)' zeros(3, 1)];
% location of bound examples
example_loc = [0 0.33 0.66];


%% compute the value function
gs = discretebelief(g_num);
[Vd, Ve] = computevalues(gs, dt, T, sig2, c);
% the actual value function is the maximum of Vd and Ve for each time-step
V = bsxfun(@max, Vd, Ve);


%% compute the resulting bounds in belief
g_bound = NaN(1, size(Ve, 1));
for i = 1:length(g_bound)
    g_bound(i) = valueintersect(gs, Vd, Ve(i,:));
end


%% plot results
N = ceil(t / dt);
example_Ns = ceil(example_loc * N) + 1;  % + 1 to avoid N = 0
ts = dt * (0:(N-1));
figure('Color', 'white');

% 'full' value function matrix with bounds
subplot(1, 2, 1);  hold on;
xlim([0 max(ts)]);  ylim([0 1]);
% value function and bounds
imagesc(ts, gs, V(1:N,:)', [0.5 1]);  colormap('bone');
plot(ts, g_bound(1:N), 'LineWidth', 3, 'Color', [0 0.8 0]);
plot(ts, 1-g_bound(1:N), 'LineWidth', 3, 'Color', [0 0.8 0]);
% mark the cuts that corresponds to the examples
for i = 1:length(example_Ns)
    plot([1 1]*ts(example_Ns(i)), ylim, 'LineWidth', 1, 'Color', cut_cols(i,:));
end
% labels
xlabel('time t');
ylabel('belief g');
set(gca,'Layer','top','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'YTick',0:0.5:1);

    
% value function examples
subplot(1, 2, 2);  hold on;
xlim([0 1]);  ylim([0, 1]);
legendstr = {'max[g, 1-g]'};
% plot Vd
plot(Vd, gs, 'LineWidth', 3, 'Color', [0.8 0 0]);
% plot the Ve's
for i = 1:length(example_Ns)
    plot(Ve(example_Ns(i),:), gs, 'LineWidth', 3, 'Color', cut_cols(i,:));
    legendstr = cat(2, legendstr, sprintf('<V>-c dt, t=%4.2f', ts(example_Ns(i))));
end
% plot the bounds (after the Ve's, to get the legend order right)
for i = 1:length(example_Ns)
    plot(xlim, [1 1]*g_bound(example_Ns(i)), 'LineWidth', 1, 'Color', bound_cols(i,:));
    plot(xlim, 1-[1 1]*g_bound(example_Ns(i)), 'LineWidth', 1, 'Color', bound_cols(i,:));
end
% legend and labels
legend(legendstr, 'Location', 'SouthWest');
xlabel('value');
ylabel('belief g');
set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:0.5:1,'YTick',0:0.5:1);
