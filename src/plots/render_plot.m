%% DESCRIPTION
%  Renders the selected plot type into the given axes.
%% INPUTS
%  ax            handle  — target axes
%  key           string  — plot type key
%  b             vector  — numerator coefficients
%  a             vector  — denominator coefficients
%  Fs            scalar  — sample rate in Hz
%  phase_wrapped logical — wrapped/unwrapped phase (used for 'phase' only)
%  freq_unit     string  — display unit: 'Hz'|'kHz'|'MHz'|'GHz'|'Normalized'
%  mag_linear    logical — true = linear magnitude scale (used for 'magnitude' only)
%% OUTPUTS
%  none

function render_plot(ax, key, b, a, Fs, phase_wrapped, freq_unit, mag_linear)
  if nargin < 6; phase_wrapped = true;   end
  if nargin < 7; freq_unit     = 'Hz';   end
  if nargin < 8; mag_linear    = false;  end
  switch key
    case 'magnitude'
      plot_magnitude(ax, b, a, Fs, freq_unit, mag_linear);
    case 'phase'
      plot_phase(ax, b, a, Fs, phase_wrapped, freq_unit);
    case 'phase_delay'
      plot_phase_delay(ax, b, a, Fs, freq_unit);
    case 'group_delay'
      plot_group_delay(ax, b, a, Fs, freq_unit);
    case 'polezero'
      plot_polezero(ax, b, a);
    case 'impulse'
      plot_impulse(ax, b, a, max(64, numel(b) + 20));
    otherwise
      cla(ax);
  end
end
