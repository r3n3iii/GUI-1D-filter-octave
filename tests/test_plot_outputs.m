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
  t_polezero_smoke_fir();
  t_polezero_smoke_iir();
  t_polezero_unit_circle();
  t_impulse_smoke_fir();
  t_impulse_smoke_iir();
  t_refresh_all_plots();
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

function t_polezero_smoke_fir()
  b = fir1(20, 0.3);
  a = 1;
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_polezero(ax, b, a);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_polezero_smoke_fir: axes has no children after plot_polezero');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_polezero_smoke_iir()
  [b, a] = butter(4, 0.3);
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_polezero(ax, b, a);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_polezero_smoke_iir: axes has no children after plot_polezero');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_polezero_unit_circle()
  % The unit circle is always drawn — verify at least one line exists
  b = fir1(10, 0.4);
  a = 1;
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_polezero(ax, b, a);
    lines = findobj(ax, 'Type', 'line');
    if isempty(lines)
      close(fig);
      error('t_polezero_unit_circle: no line objects found — unit circle not drawn');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_impulse_smoke_fir()
  b = fir1(20, 0.3);
  a = 1;
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_impulse(ax, b, a, 64);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_impulse_smoke_fir: axes has no children after plot_impulse');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_impulse_smoke_iir()
  [b, a] = butter(4, 0.3);
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_impulse(ax, b, a, 64);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_impulse_smoke_iir: axes has no children after plot_impulse');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_refresh_all_plots()
  b = fir1(20, 0.3);
  a = 1;
  fig = figure('visible', 'off');
  handles.b      = b;
  handles.a      = a;
  handles.Fs     = 8000;
  handles.ax_mag = axes('Parent', fig);
  handles.ax_pz  = axes('Parent', fig);
  handles.ax_imp = axes('Parent', fig);
  try
    refresh_all_plots(handles);
    if isempty(get(handles.ax_mag, 'Children'))
      close(fig);
      error('t_refresh_all_plots: ax_mag has no children');
    end
    if isempty(get(handles.ax_pz, 'Children'))
      close(fig);
      error('t_refresh_all_plots: ax_pz has no children');
    end
    if isempty(get(handles.ax_imp, 'Children'))
      close(fig);
      error('t_refresh_all_plots: ax_imp has no children');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end
