function plot_valueintersect(sig2, c)
%% plots example value functions and where Vd and Ve intersect
%
% sig2 and c are the momentary evidence variance and evidence accumulation
% cost, respectively. If not given, they are set to sig2 = 1 and c = 0.2.

%% settings
% momentary evidence variance
if nargin < 1, sig2 = 1; end
% evidence accumulation cost
if nargin < 2, c = 0.2; end
% discretisation of belief (coarse, as only for illustraction purposes)
g_num = 100;
% time-step for belief transition (large for illustration purposes)
dt = 0.2;


%% compute values and point where they intersect
gs = discretebelief(g_num);
[Vd, Ve] = valueiteration(gs, dt, sig2, c);
g = valueintersect(gs, Vd, Ve);


%% plot results
figure('Color', 'white');  hold on;
xlim([0 1]);  ylim([0 1]);
% plot values
plot(gs, Vd, 'LineWidth', 3, 'Color', [0.8 0 0]);
plot(gs, Ve, 'LineWidth', 3, 'Color', [0 0 0.8]);
% plot intersection
plot([1 1] * g, ylim, 'LineWidth', 1, 'Color', [1 1 1] * 0.5);
plot([1 1] * (1-g), ylim, 'LineWidth', 1, 'Color', [1 1 1] * 0.5);
legend('max(g, 1-g)', '<V> - c dt', 'Location', 'SouthEast');
xlabel('belief c');
ylabel('value');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02);
