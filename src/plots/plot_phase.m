%% DESCRIPTION
%  Plots the phase response in radians on the given axes.
%% INPUTS
%  ax         handle  — target axes
%  b          vector  — numerator coefficients
%  a          vector  — denominator coefficients
%  Fs         scalar  — sample rate in Hz
%  wrapped    logical — true = wrapped [-pi,pi], false = unwrapped continuous
%  freq_unit  string  — display unit: 'Hz'|'kHz'|'MHz'|'GHz'|'Normalized'
%% OUTPUTS
%  none

function plot_phase(ax, b, a, Fs, wrapped, freq_unit)
  if nargin < 5; wrapped   = true; end
  if nargin < 6; freq_unit = 'Hz'; end
  cla(ax);

  [H, f] = freqz(b, a, 512, Fs);
  ph = angle(H);
  if ~wrapped
    ph = unwrap(ph);
  end

  [scale, freq_lbl] = freq_axis_scale(freq_unit, Fs);

  plot(ax, f / scale, ph);
  grid(ax, 'on');
  if wrapped
    lbl = 'Phase Response (wrapped)';
  else
    lbl = 'Phase Response (unwrapped)';
  end
  th = title(ax, lbl);
  set(th, 'FontSize', 11);
  xlabel(ax, freq_lbl);
  ylabel(ax, 'Phase (radians)');
  xlim(ax, [0, Fs/2/scale]);
end
