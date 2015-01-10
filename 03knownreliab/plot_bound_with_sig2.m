function plot_bound_with_sig2(c)
%% plots how the bound changes with increasing task difficulty
%
% c is the cost for accumulating evidence. If not given, it defaults to
% 0.1.

%% settings
if nargin < 1, c = 0.1; end
% sig's to consider
sig_num = 40;
sigs = linspace(0.1, 4, sig_num);
% belief discretisation
g_num = 500;
% time step for belief transition
dt = 0.0005;


%% belief discretisation and transition
gs = discretebelief(g_num);


%% compute bound by sig, using dp and non-dp approach
gdp = zeros(1, sig_num);
gnodp = zeros(1, sig_num);
h = waitbar(0, 'Computing bound for different task difficulties');
for sig_idx = 1:sig_num
    waitbar(sig_idx / sig_num, h);
    sig2 = sigs(sig_idx)^2;
    % dynamic programming approach to find the bound
    [Vd, Ve] = valueiteration(gs, dt, sig2, c);
    gdp(sig_idx) = valueintersect(gs, Vd, Ve);
    % find bound (in x rather than g) by maximizing expected reward
    x = nondpbound(sig2, c);
    gnodp(sig_idx) = 1 / (1 + exp(-2 * x / sig2)); % use x -> g mapping
end
close(h);


%% plot bounds over costs
figure('Color', 'white');  hold on;
xlim([0 max(sigs)]);  ylim([0.5 1]);
plot(sigs, gnodp, ':', 'LineWidth', 3, 'Color', [1 1 1]*0.5);
plot(sigs, gdp, 'k', 'LineWidth', 3);
legend('direct', 'DP');
xlabel('task difficulty sqrt(sig2)');
ylabel('bound in belief');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02);
