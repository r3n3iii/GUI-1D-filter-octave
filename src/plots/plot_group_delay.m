%% DESCRIPTION
%  Plots the group delay in samples on the given axes.
%  Clips outlier spikes to the 5th-95th percentile range so pole-related
%  transients do not dominate the y-axis (matches filterDesigner behaviour).
%% INPUTS
%  ax         handle — target axes
%  b          vector — numerator coefficients
%  a          vector — denominator coefficients
%  Fs         scalar — sample rate in Hz
%  freq_unit  string — display unit: 'Hz'|'kHz'|'MHz'|'GHz'|'Normalized'
%% OUTPUTS
%  none

function plot_group_delay(ax, b, a, Fs, freq_unit)
  if nargin < 5; freq_unit = 'Hz'; end
  cla(ax);

  ws = warning('off', 'all');
  try
    [gd, f] = grpdelay(b, a, 512, Fs);
  catch
    warning(ws);
    th = title(ax, 'Group Delay');
    set(th, 'FontSize', 11);
    return;
  end
  warning(ws);

  % grpdelay sets singularity points to exactly 0; replace with NaN so
  % they render as gaps rather than pulling the scale down
  gd(gd == 0)        = NaN;
  gd(~isfinite(gd))  = NaN;
  valid = ~isnan(gd);

  if sum(valid) < 2
    th = title(ax, 'Group Delay');
    set(th, 'FontSize', 11);
    return;
  end

  % Clip to 5th-95th percentile to suppress pole-related spikes
  gd_sorted = sort(gd(valid));
  n         = numel(gd_sorted);
  y_lo      = gd_sorted(max(1,           round(0.05 * n)));
  y_hi      = gd_sorted(min(n,           round(0.95 * n)));
  margin    = max((y_hi - y_lo) * 0.15, 1);  % at least 1 sample headroom

  gd = max(y_lo - margin, min(y_hi + margin, gd));

  [scale, freq_lbl] = freq_axis_scale(freq_unit, Fs);

  plot(ax, f / scale, gd);
  grid(ax, 'on');
  th = title(ax, 'Group Delay');
  set(th, 'FontSize', 11);
  xlabel(ax, freq_lbl);
  ylabel(ax, 'Group Delay (samples)');
  xlim(ax, [0, Fs/2/scale]);
  ylim(ax, [y_lo - margin, y_hi + margin]);
end
