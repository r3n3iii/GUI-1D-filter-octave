%% DESCRIPTION
%  Plots the phase delay in samples on the given axes.
%  Phase delay = -phase(w) / w, distinct from group delay = -d(phase)/dw.
%% INPUTS
%  ax         handle — target axes
%  b          vector — numerator coefficients
%  a          vector — denominator coefficients
%  Fs         scalar — sample rate in Hz
%  freq_unit  string — display unit: 'Hz'|'kHz'|'MHz'|'GHz'|'Normalized'
%% OUTPUTS
%  none

function plot_phase_delay(ax, b, a, Fs, freq_unit)
  if nargin < 5; freq_unit = 'Hz'; end
  cla(ax);

  [H, f] = freqz(b, a, 512, Fs);
  w     = 2 * pi * f / Fs;          % rad/sample
  phase = unwrap(angle(H));

  pd      = zeros(size(w));
  nz      = w ~= 0;
  pd(nz)  = -phase(nz) ./ w(nz);
  % DC: use the first non-DC value as an approximation
  first_nz    = find(nz, 1);
  pd(~nz)     = pd(first_nz);

  % Clip outliers (same strategy as group delay)
  pd_sorted = sort(pd);
  n         = numel(pd_sorted);
  y_lo      = pd_sorted(max(1,   round(0.05 * n)));
  y_hi      = pd_sorted(min(n,   round(0.95 * n)));
  margin    = max((y_hi - y_lo) * 0.15, 1);
  pd        = max(y_lo - margin, min(y_hi + margin, pd));

  [scale, freq_lbl] = freq_axis_scale(freq_unit, Fs);

  plot(ax, f / scale, pd);
  grid(ax, 'on');
  th = title(ax, 'Phase Delay');
  set(th, 'FontSize', 11);
  xlabel(ax, freq_lbl);
  ylabel(ax, 'Phase Delay (samples)');
  xlim(ax, [0, Fs/2/scale]);
  ylim(ax, [y_lo - margin, y_hi + margin]);
end
