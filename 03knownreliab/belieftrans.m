function gg = belieftrans(gs, dt, sig2)
%% Returns the belief transition matrix p(g' | g)
%
% The N x N belief transition matrix gg specifies for each belief gk the
% probability p(gj | gk) of transitioning to belief gj after observing dt
% more evidence. Element gg(k, j) holds p(gj | gk). The entries in the
% matrix are adequately normalised such that sum_j gg(k, j) = 1.
% 
% The matrix is computed over the N-element belief row vector gs. gs should
% neither include 0 as 1, as these cause numerical issues.
% 
% sig2 specifies the variance of the momentary evidence likelihood
% p(dx | z dt, sig2 dt).

% the below computes
% p(gj | gk) = 1/Z exp(-(X(gj)-X(gk))^2 / (2 sig2 dt)) / (gj (1 - gj)) *
%              ( gk exp((X(gj)-X(gk)) / sig2) + 
%                (1 - gk) exp(- (X(gj)-X(gk)) / sig2) )
% which only includes terms that are vary with g' (i.e. gj).

% sufficient statistics X(g) corresponding to each belief in gs
Xs = (sig2 / 2) * log(gs ./ (1 - gs));
% matrix of X(g') - X(g), with g along columns and g' along rows
Xdiff = bsxfun(@minus, Xs, Xs');

% mixture components of the transition matrix
ggmix = bsxfun(@times, gs', exp(Xdiff / sig2)) + ...
        bsxfun(@times, 1 - gs', exp(-Xdiff / sig2));
% common pre-factor
ggpre = bsxfun(@rdivide, exp(- Xdiff.^2 / (2 * sig2 * dt)), gs .* (1 - gs));

% compute gg and normalize it
gg = ggmix .* ggpre;
gg = bsxfun(@rdivide, gg, sum(gg, 2));