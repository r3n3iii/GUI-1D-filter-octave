%% DESCRIPTION
%  Creates the main figure and top-level layout. Returns handles struct.
%% INPUTS
%  none
%% OUTPUTS
%  handles  struct — contains all widget handles and application state

function handles = build_main_window()
  fig = figure( ...
    'Name',        'Octave Filter Designer', ...
    'NumberTitle', 'off', ...
    'MenuBar',     'none', ...
    'ToolBar',     'none', ...
    'Position',    [100 100 1100 650], ...
    'Resize',      'on');

  % Left control panel (~280 px wide, normalized)
  ctrl_panel = uipanel( ...
    'Parent',   fig, ...
    'Units',    'normalized', ...
    'Position', [0.00 0.00 0.26 1.00], ...
    'BorderType', 'none');

  % Right plot panel — remainder of window
  plot_panel = uipanel( ...
    'Parent',   fig, ...
    'Units',    'normalized', ...
    'Position', [0.26 0.00 0.74 1.00], ...
    'BorderType', 'none');

  ctrl_handles = build_control_panel(ctrl_panel);
  plot_handles = build_plot_panel(plot_panel);

  % Merge into one handles struct
  handles = ctrl_handles;
  fields  = fieldnames(plot_handles);
  for i = 1:numel(fields)
    handles.(fields{i}) = plot_handles.(fields{i});
  end

  % Default application state
  handles.fig           = fig;
  handles.filter_type   = 'FIR';
  handles.design_method = 'window';
  handles.b             = fir1(40, 0.3);
  handles.a             = 1;
  handles.Fs            = 2;

  guidata(fig, handles);

  % Draw default filter on startup
  refresh_all_plots(handles);
end
