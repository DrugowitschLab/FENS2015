function plot_bound_with_cost(sig2)
%% plots how the bound changes with increasing accumulation cost
%
% sig2 is the variance of the momentary evidence. If not given, it defaults
% to 1.

%% settings
if nargin < 1, sig2 = 1; end
% costs to consider
c_num = 40;
cs = linspace(0.001, 1, c_num);
% belief discretisation
g_num = 500;
% time step for belief transition
dt = 0.0005;


%% belief discretisation and transition
gs = discretebelief(g_num);


%% compute bound by cost, using dp and non-dp approach
gdp = zeros(1, c_num);
gnodp = zeros(1, c_num);
h = waitbar(0, 'Computing bound for different costs');
for c_idx = 1:c_num
    waitbar(c_idx / c_num, h);
    % dynamic programming approach to find the bound
    [Vd, Ve] = valueiteration(gs, dt, sig2, cs(c_idx));
    gdp(c_idx) = valueintersect(gs, Vd, Ve);
    % find bound (in x rather than g) by maximizing expected reward
    x = nondpbound(sig2, cs(c_idx));
    gnodp(c_idx) = 1 / (1 + exp(-2 * x / sig2));
end
close(h);


%% plot bounds over costs
figure('Color', 'white');  hold on;
xlim([0 max(cs)]);  ylim([0.5 1]);
plot(cs, gnodp, ':', 'LineWidth', 3, 'Color', [1 1 1]*0.5);
plot(cs, gdp, 'k', 'LineWidth', 3);
legend('direct', 'DP');
xlabel('evidence accumulation cost c');
ylabel('bound in belief');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02);
