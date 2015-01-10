function single_obs(sig2)
%% plot belief after single observation
%
% The function assumes the likelihood function,
% p(x | z) = N(x | z, sig2)
% where z is in {-1, 1}. Given a single observed x, it plots the posterior
% p(z = 1 | x)
% and additionally the likelihood functions associated with either
% hypothesis about z.
%
% sig2 specifies the task difficulty (small/large sig2 = easy/hard task).
% If not given, it defaults to 1.

%% settings
% task difficulty. small/large sig2 = easy/hard task
if nargin < 1, sig2 = 1^2; end
% plot colors for z=1 / z=-1
z1col = [0.3 0.67 0.77];
zm1col = [0.97 0.59 0.27];


%% compute posterior and likelihoods
xs = linspace(-4, 4, 100);
% p(z=1 | g)
pz1gx = 1 ./ (1 + exp(-2 * xs / sig2));
% p(x | z=1)
pxgz1 = exp(- (xs - 1).^2 / (2 * sig2)) / sqrt(2 * pi * sig2);
% p(x | z=-1)
pxgzm1 = exp(- (xs + 1).^2 / (2 * sig2)) / sqrt(2 * pi * sig2);


%% plot posterior belief and likelihood densities
figure('Color', 'white');  hold on;
xlim([min(xs) max(xs)]);  ylim([0 1]);
% posterior probability
plot(xs, pz1gx, 'k', 'LineWidth', 4);
% rescale likelihoods if they exceed 1
lh_scale = 1 / max(1, max(pxgz1));
plot(xs, lh_scale * pxgz1, 'LineWidth', 3, 'Color', z1col);
plot(xs, lh_scale * pxgzm1, 'LineWidth', 3, 'Color', zm1col);
% guides
plot(xlim, [0.5 0.5], 'k--', 'LineWidth', 1);
plot([0 0], ylim, 'k--', 'LineWidth', 1);
plot([-1 -1], ylim, 'k--', 'LineWidth', 1);
plot([1 1], ylim, 'k--', 'LineWidth', 1);
% labels and legends
xlabel('x');
ylabel('posterior and likelihood');
legend('p(z = 1 | x)', 'p(x | z = 1)', 'p(x | z = -1)',...
       'Location','NorthWest');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[4/3,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',-4:1:4);
