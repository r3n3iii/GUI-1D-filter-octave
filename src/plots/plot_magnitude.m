%% DESCRIPTION
%  Plots the magnitude frequency response in dB on the given axes.
%% INPUTS
%  ax  handle — target axes
%  b   vector — numerator coefficients
%  a   vector — denominator coefficients
%  Fs  scalar — sample rate in Hz
%% OUTPUTS
%  none

function plot_magnitude(ax, b, a, Fs)
  cla(ax);

  [H, f] = freqz(b, a, 512, Fs);
  mag_db = 20 * log10(max(abs(H), 1e-10));

  plot(ax, f, mag_db);
  grid(ax, 'on');
  title(ax, 'Magnitude Response');
  ylabel(ax, 'Magnitude (dB)');

  if Fs == 2
    xlabel(ax, 'Normalized Frequency (\times\pi rad/sample)');
    xlim(ax, [0 1]);
  else
    xlabel(ax, 'Frequency (Hz)');
    xlim(ax, [0 Fs/2]);
  end
end
