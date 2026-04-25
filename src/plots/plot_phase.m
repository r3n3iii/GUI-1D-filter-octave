%% DESCRIPTION
%  Plots the phase response in degrees on the given axes.
%% INPUTS
%  ax  handle — target axes
%  b   vector — numerator coefficients
%  a   vector — denominator coefficients
%  Fs  scalar — sample rate in Hz
%% OUTPUTS
%  none

function plot_phase(ax, b, a, Fs)
  cla(ax);

  [H, f] = freqz(b, a, 512, Fs);
  phase_deg = angle(H) * 180 / pi;

  plot(ax, f, phase_deg);
  grid(ax, 'on');
  th = title(ax, 'Phase Response');
  set(th, 'FontSize', 11);
  xlabel(ax, 'Frequency (Hz)');
  ylabel(ax, 'Phase (degrees)');
  xlim(ax, [0 Fs/2]);
end
