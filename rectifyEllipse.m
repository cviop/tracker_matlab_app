function [x_circ, y_circ] = rectifyEllipse(x, y)
%RECTIFYELLIPSE  Shift, un-skew & un-scale an ellipse so it becomes a unit circle at [0,0]
%
%   [x_circ, y_circ] = rectifyEllipse(x, y)
%
% Inputs:
%   x, y      - vectors (Nx1 or 1xN) of ellipse coordinates
%
% Outputs:
%   x_circ, y_circ  - same-size vectors of the corrected circle (unit radius)
%
% Example:
%   % generate an ellipse by scaling, rotating & translating a circle
%   theta = linspace(0,2*pi,200);
%   X = [cos(theta); sin(theta)];
%   A = [2 0.5; 0.2 1.5];        % arbitrary affine transform
%   T = [1.3; -0.7];             % translation
%   P = A*X + T;
%   [xc, yc] = rectifyEllipse(P(1,:)', P(2,:)');
%   plot(xc, yc, 'o'), axis equal

    % ensure column vectors
    x = x(:);
    y = y(:);

    %--- 1) find & remove center ------------------------------------------------
    cx = mean(x);
    cy = mean(y);
    Xc = x - cx;
    Yc = y - cy;

    %--- 2) compute covariance of centered data ---------------------------------
    M = [Xc, Yc];
    C = cov(M);    % 2×2

    %--- 3) eigendecomposition & build whitening matrix -------------------------
    [V, D] = eig(C);
    % D = diag(lambda1, lambda2);  V = [evec1, evec2]
    W = V * diag(1 ./ sqrt(diag(D))) * V';  

    %--- 4) apply whitening transform & normalize to unit radius ----------------
    XYw = W * M';                              % 2×N
    radii = sqrt(sum(XYw.^2,1));               % 1×N
    r_mean = mean(radii);                      % should be constant if perfect
    XYc = XYw / r_mean;                        % now ‖[x;y]‖ ≈ 1
    XYc = XYc*max([std(x) std(y)]);

    % return as column vectors
    x_circ = XYc(1,:)';
    y_circ = XYc(2,:)';
end