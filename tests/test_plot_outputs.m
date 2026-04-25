%% DESCRIPTION
%  Checks that plot functions produce axes handles without error.
%% INPUTS
%  none
%% OUTPUTS
%  none — throws on failure

function test_plot_outputs()
  t_magnitude_smoke_fir();
  t_magnitude_smoke_iir();
  t_magnitude_normalized_xlabel();
  t_magnitude_hz_xlabel();
end

function t_magnitude_smoke_fir()
  b = fir1(20, 0.3);
  a = 1;
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_magnitude(ax, b, a, 2);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_magnitude_smoke_fir: axes has no children after plot_magnitude');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_magnitude_smoke_iir()
  [b, a] = butter(4, 0.3);
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_magnitude(ax, b, a, 2);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_magnitude_smoke_iir: axes has no children after plot_magnitude');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_magnitude_normalized_xlabel()
  b = fir1(20, 0.3);
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_magnitude(ax, b, 1, 2);
    lim = xlim(ax);
    if lim(2) ~= 1
      close(fig);
      error('t_magnitude_normalized_xlabel: xlim should end at 1 for Fs=2, got %g', lim(2));
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_magnitude_hz_xlabel()
  b = fir1(20, 0.3);
  Fs = 8000;
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_magnitude(ax, b, 1, Fs);
    lim = xlim(ax);
    if lim(2) ~= Fs/2
      close(fig);
      error('t_magnitude_hz_xlabel: xlim should end at Fs/2=%g, got %g', Fs/2, lim(2));
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end
