function plot_belieftrans
%% plots of few example belief transition matrices
%
% The shown belief transition matrices are for different t's, as well as
% for different sig2's (that determines the task difficulty)

%% settings
% belief discretisation
g_num = 100;
% time step-size
dt = 0.01;
% base parameters
t = 0.5;
sig2 = 1;
% parameter variations
ts = [0 0.5 4];
sig2s = [0.5^2 1^2 5^2];
t_num = length(ts);
sig2_num = length(sig2s);


%% discretised belief
gs = discretebelief(g_num);
invgs = norminv(gs);


%% plot belief transition examples
figure('Color', 'white');
% varying time step size
for t_idx = 1:t_num
    subplot(2, 3, t_idx);
    gg = belieftrans(invgs, dt / (ts(t_idx) + 1/sig2));
    gg = addconfregsion(gg);
    imagesc(gs, gs, 1-sqrt(gg));  colormap('bone');
    % labels
    set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:0.5:1,'YTick',0:0.5:1);
    title(sprintf('t = %4.2f, \\sigma_\\alpha^2 = %4.2f', ts(t_idx), sig2));
    if t_idx == 1, ylabel('g'); end
end
% varying task difficulty
for sig2_idx = 1:sig2_num
    subplot(2, 3, sig2_idx + 3);
    gg = belieftrans(invgs, dt / (t + 1/sig2s(sig2_idx)));
    gg = addconfregsion(gg);
    imagesc(gs, gs, 1-sqrt(gg));  colormap('bone');
    % labels
    set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:0.5:1,'YTick',0:0.5:1);
    title(sprintf('t = %4.2f, \\sigma_\\alpha^2 = %4.2f', t, sig2s(sig2_idx)));
    if sig2_idx == 1, ylabel('g'); end
    xlabel('g''');
end


function gg = addconfregsion(gg)
%% adds the 95% confidence region to the probability distributions

for k = 1:size(gg, 1)
    gcum = cumsum(gg(k,:));
    % find 2.5 and 97.5 percentiles of the cumulative
    li = find(gcum >= 0.025, 1, 'first');
    ui = find(gcum < 0.975, 1, 'last');
    if isempty(ui), ui = 1;
    else ui = ui + 1; end
    % mark them in the distribution
    gg(k, li) = 1;
    gg(k, ui) = 1;
end