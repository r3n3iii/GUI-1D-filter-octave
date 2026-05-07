%% DESCRIPTION
%  Plots the magnitude frequency response on the given axes.
%% INPUTS
%  ax         handle  — target axes
%  b          vector  — numerator coefficients
%  a          vector  — denominator coefficients
%  Fs         scalar  — sample rate in Hz
%  freq_unit  string  — display unit: 'Hz'|'kHz'|'MHz'|'GHz'|'Normalized'
%  linear     logical — true = linear scale, false = dB (default false)
%% OUTPUTS
%  none

function plot_magnitude(ax, b, a, Fs, freq_unit, linear)
  if nargin < 5; freq_unit = 'Hz';   end
  if nargin < 6; linear    = false;  end
  cla(ax);

  [H, f] = freqz(b, a, 512, Fs);

  [scale, freq_lbl] = freq_axis_scale(freq_unit, Fs);

  if linear
    plot(ax, f / scale, abs(H));
    ylabel(ax, 'Magnitude');
    title(ax, 'Magnitude Response (Linear)');
  else
    mag_db = 20 * log10(max(abs(H), 1e-10));
    plot(ax, f / scale, mag_db);
    ylabel(ax, 'Magnitude (dB)');
    title(ax, 'Magnitude Response');
  end

  grid(ax, 'on');
  set(get(ax, 'Title'), 'FontSize', 11);
  xlabel(ax, freq_lbl);
  xlim(ax, [0, Fs/2/scale]);
end
