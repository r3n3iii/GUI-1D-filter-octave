%% DESCRIPTION
%  Renders the selected plot type into the given axes.
%% INPUTS
%  ax   handle — target axes
%  key  string — plot type key
%  b    vector — numerator coefficients
%  a    vector — denominator coefficients
%  Fs   scalar — sample rate in Hz
%% OUTPUTS
%  none

function render_quadrant(ax, key, b, a, Fs)
  switch key
    case 'magnitude'
      plot_magnitude(ax, b, a, Fs);
    case 'phase'
      plot_phase(ax, b, a, Fs);
    case 'group_delay'
      plot_group_delay(ax, b, a, Fs);
    case 'polezero'
      plot_polezero(ax, b, a);
    case 'impulse'
      N = max(64, numel(b) + 20);
      plot_impulse(ax, b, a, N);
    otherwise
      cla(ax);
  end
end
