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
  handles.fpass         = 900  / (8000/2);   % normalized passband edge
  handles.fstop         = 1100 / (8000/2);   % normalized stopband edge
  handles.fpass2        = 2000 / (8000/2);   % 2-band upper passband edge
  handles.fstop2        = 2200 / (8000/2);   % 2-band upper stopband edge
  handles.Wpass          = 1;
  handles.Wstop          = 1;
  handles.density_factor = 20;
  handles.active_plot   = 'magnitude';
  handles.phase_wrapped = true;
  handles.freq_unit     = 'Hz';

  guidata(fig, handles);

  build_menu(fig);
  set(handles.btn_reset,     'Callback', @cb_reset);
  set(handles.btn_design,    'Callback', @cb_design_clicked);
  set(handles.btn_import,    'Callback', @cb_import_coeffs);
  set(handles.btn_export,    'Callback', @cb_export_coeffs);
  set(handles.rb_fir,        'Callback', @cb_filter_type);
  set(handles.rb_iir,        'Callback', @cb_filter_type);
  set(handles.dd_method,     'Callback', @cb_method_changed);
  set(handles.dd_band,       'Callback', @(h,e) apply_param_visibility(guidata(h)));
  set(handles.dd_window,     'Callback', @(h,e) apply_param_visibility(guidata(h)));
  set(handles.dd_freq_unit,  'Callback', @cb_freq_unit_changed);
  set(handles.dd_structure,  'Callback', @cb_structure_changed);
  set(handles.ed_order,      'Callback', @cb_order_changed);
  set(handles.ed_wn,         'Callback', @cb_freq_changed);

  PLOT_KEYS = {'magnitude','phase','phase_delay','group_delay', ...
               'polezero','impulse','coefficients'};
  for i = 1:numel(handles.btns_plot)
    key = PLOT_KEYS{i};
    set(handles.btns_plot(i), 'Callback', @(h,e) cb_plot_select(h, key));
  end
  set(handles.btn_phase_wrap, 'Callback', @cb_phase_wrap_toggle);

  apply_param_visibility(handles);

  % Draw default filter on startup
  refresh_all_plots(handles);
end
