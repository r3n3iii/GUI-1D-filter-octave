%% DESCRIPTION
%  Plots the magnitude frequency response in dB on the given axes.
%% INPUTS
%  ax         handle — target axes
%  b          vector — numerator coefficients
%  a          vector — denominator coefficients
%  Fs         scalar — sample rate in Hz
%  freq_unit  string — display unit: 'Hz'|'kHz'|'MHz'|'GHz'|'Normalized'
%% OUTPUTS
%  none

function plot_magnitude(ax, b, a, Fs, freq_unit)
  if nargin < 5; freq_unit = 'Hz'; end
  cla(ax);

  [H, f] = freqz(b, a, 512, Fs);
  mag_db = 20 * log10(max(abs(H), 1e-10));

  [scale, freq_lbl] = freq_axis_scale(freq_unit, Fs);

  plot(ax, f / scale, mag_db);
  grid(ax, 'on');
  th = title(ax, 'Magnitude Response');
  set(th, 'FontSize', 11);
  xlabel(ax, freq_lbl);
  ylabel(ax, 'Magnitude (dB)');
  xlim(ax, [0, Fs/2/scale]);
end
