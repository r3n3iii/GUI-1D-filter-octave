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
  handles.filter_order  = 40;
  handles.Fs            = 8000;
  handles.Wn            = 1000 / (8000/2);   % 0.25 normalized
  handles.band_type     = 'low';
  handles.window_type   = 'hamming';
  handles.kaiser_beta   = 5;
  handles.Rp            = 1;
  handles.Rs            = 40;
  handles.b             = fir1(40, handles.Wn);
  handles.a             = 1;

  guidata(fig, handles);

  build_menu(fig);
  set(handles.btn_reset,   'Callback', @cb_reset);
  set(handles.btn_design,  'Callback', @cb_design_clicked);
  set(handles.btn_export,  'Callback', @cb_export_coeffs);
  set(handles.rb_fir,      'Callback', @cb_filter_type);
  set(handles.rb_iir,      'Callback', @cb_filter_type);
  set(handles.dd_method,   'Callback', @cb_method_changed);
  set(handles.dd_window,   'Callback', @(h,e) apply_param_visibility(guidata(h)));
  set(handles.ed_order,    'Callback', @cb_order_changed);
  set(handles.ed_wn,       'Callback', @cb_freq_changed);

  apply_param_visibility(handles);

  % Draw default filter on startup
  refresh_all_plots(handles);
end
