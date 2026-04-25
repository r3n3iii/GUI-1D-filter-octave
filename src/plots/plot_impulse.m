%% DESCRIPTION
%  Plots the impulse response on the given axes.
%% INPUTS
%  ax  handle — target axes
%  b   vector — numerator coefficients
%  a   vector — denominator coefficients
%  N   scalar — number of samples to compute
%% OUTPUTS
%  none

function plot_impulse(ax, b, a, N)
  cla(ax);

  [h, t] = impz(b, a, N);

  stem(ax, t, h, 'filled', 'MarkerSize', 3);
  grid(ax, 'on');
  title(ax, 'Impulse Response');
  xlabel(ax, 'Samples (n)');
  ylabel(ax, 'Amplitude');
end
