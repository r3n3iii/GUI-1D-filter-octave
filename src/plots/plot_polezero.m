%% DESCRIPTION
%  Plots the pole-zero diagram with unit circle on the given axes.
%% INPUTS
%  ax  handle — target axes
%  b   vector — numerator coefficients (zeros)
%  a   vector — denominator coefficients (poles)
%% OUTPUTS
%  none

function plot_polezero(ax, b, a)
  cla(ax);
  hold(ax, 'on');

  % Unit circle
  theta = linspace(0, 2*pi, 256);
  plot(ax, cos(theta), sin(theta), 'k--', 'LineWidth', 0.8);

  % Zeros (roots of b)
  z = roots(b);
  if ~isempty(z)
    plot(ax, real(z), imag(z), 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);
  end

  % Poles (roots of a) — a==1 for FIR, roots([1]) returns empty
  p = roots(a);
  if ~isempty(p) && ~(numel(p) == 1 && p == 0)
    plot(ax, real(p), imag(p), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
  end

  hold(ax, 'off');
  axis(ax, 'equal');
  grid(ax, 'on');
  title(ax, 'Pole-Zero Plot');
  xlabel(ax, 'Real');
  ylabel(ax, 'Imaginary');
end
