%% DESCRIPTION
%  Plots the group delay in samples on the given axes.
%% INPUTS
%  ax  handle — target axes
%  b   vector — numerator coefficients
%  a   vector — denominator coefficients
%  Fs  scalar — sample rate in Hz
%% OUTPUTS
%  none

function plot_group_delay(ax, b, a, Fs)
  cla(ax);

  [gd, f] = grpdelay(b, a, 512, Fs);

  plot(ax, f, gd);
  grid(ax, 'on');
  th = title(ax, 'Group Delay');
  set(th, 'FontSize', 11);
  xlabel(ax, 'Frequency (Hz)');
  ylabel(ax, 'Group Delay (samples)');
  xlim(ax, [0 Fs/2]);
end
