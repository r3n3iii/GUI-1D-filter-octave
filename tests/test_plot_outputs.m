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
  t_phase_smoke();
  t_group_delay_smoke();
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
  b  = fir1(20, 0.3);
  Fs = 2;
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_magnitude(ax, b, 1, Fs);
    lim = xlim(ax);
    if lim(2) ~= Fs/2
      close(fig);
      error('t_magnitude_normalized_xlabel: xlim should end at %g for Fs=%g, got %g', Fs/2, Fs, lim(2));
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

function t_phase_smoke()
  b = fir1(20, 0.3);
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_phase(ax, b, 1, 8000);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_phase_smoke: axes has no children after plot_phase');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_group_delay_smoke()
  b = fir1(20, 0.3);
  fig = figure('visible', 'off');
  ax  = axes('Parent', fig);
  try
    plot_group_delay(ax, b, 1, 8000);
    if isempty(get(ax, 'Children'))
      close(fig);
      error('t_group_delay_smoke: axes has no children after plot_group_delay');
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end

function t_refresh_all_plots()
  PLOT_STRINGS = {'Magnitude', 'Phase', 'Group Delay', 'Pole-Zero', 'Impulse'};
  b = fir1(20, 0.3);
  a = 1;
  fig = figure('visible', 'off');
  handles.b      = b;
  handles.a      = a;
  handles.Fs     = 8000;
  handles.ax_q1  = axes('Parent', fig);
  handles.ax_q2  = axes('Parent', fig);
  handles.ax_q3  = axes('Parent', fig);
  handles.dd_q1  = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
    'String', PLOT_STRINGS, 'Value', 1, 'Visible', 'off');
  handles.dd_q2  = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
    'String', PLOT_STRINGS, 'Value', 4, 'Visible', 'off');
  handles.dd_q3  = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
    'String', PLOT_STRINGS, 'Value', 5, 'Visible', 'off');
  try
    refresh_all_plots(handles);
    for q = 1:3
      ax_f = sprintf('ax_q%d', q);
      if isempty(get(handles.(ax_f), 'Children'))
        close(fig);
        error('t_refresh_all_plots: %s has no children', ax_f);
      end
    end
  catch e
    close(fig);
    rethrow(e);
  end
  close(fig);
end
