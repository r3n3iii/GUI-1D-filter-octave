%% DESCRIPTION
%  Callback: resets all controls and state to defaults.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_reset(hobj, evt)
  handles = guidata(hobj);

  handles.filter_type   = 'FIR';
  handles.design_method = 'window';
  handles.filter_order  = 40;
  handles.Fs            = 8000;
  handles.Wn            = 1000 / (8000/2);
  handles.band_type     = 'low';
  handles.window_type   = 'hamming';
  handles.kaiser_beta   = 5;
  handles.Rp            = 1;
  handles.Rs            = 40;
  handles.b             = fir1(40, handles.Wn);
  handles.a             = 1;

  set(handles.rb_fir,        'Value', 1);
  set(handles.rb_iir,        'Value', 0);
  set(handles.dd_method,     'String', {'Window', 'Least-Squares', 'Parks-McClellan'}, 'Value', 1);
  set(handles.dd_band,       'Value', 1);
  set(handles.ed_order,      'String', '40');
  set(handles.ed_wn,         'String', '1000');
  set(handles.ed_fs,         'String', '8000', 'Visible', 'on');
  set(handles.lbl_fs,        'String', 'Fs (Hz):', 'Visible', 'on');
  set(handles.dd_freq_unit,  'Value', 1);
  set(handles.dd_window,     'Value', 1, 'Visible', 'on');
  set(handles.ed_kaiser,     'Visible', 'off');
  set(handles.ed_rp,         'Visible', 'off');
  set(handles.ed_rs,         'Visible', 'off');
  handles.freq_unit = 'Hz';
  set(handles.lbl_stability, 'Visible', 'off');

  handles.active_plot   = 'magnitude';
  handles.phase_wrapped = true;
  set(handles.btn_phase_wrap, 'String', 'Wrapped', ...
    'BackgroundColor', [0.30 0.60 1.00], 'ForegroundColor', [1 1 1], ...
    'Visible', 'off');
  for i = 1:numel(handles.btns_plot)
    if i == 1
      set(handles.btns_plot(i), 'BackgroundColor', [0.30 0.60 1.00], 'ForegroundColor', [1 1 1]);
    else
      set(handles.btns_plot(i), 'BackgroundColor', [0.94 0.94 0.94], 'ForegroundColor', [0 0 0]);
    end
  end

  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();
end
