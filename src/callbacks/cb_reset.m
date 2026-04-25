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
  handles.b             = fir1(40, 0.3);
  handles.a             = 1;
  handles.Fs            = 2;

  set(handles.rb_fir,    'Value', 1);
  set(handles.rb_iir,    'Value', 0);
  set(handles.dd_method, 'String', {'Window', 'Least-Squares', 'Parks-McClellan'}, 'Value', 1);
  set(handles.dd_band,   'Value', 1);
  set(handles.ed_order,  'String', '40');
  set(handles.ed_wn,     'String', '0.3');
  set(handles.ed_fs,     'String', '2');
  set(handles.dd_window, 'Value', 1, 'Visible', 'on');
  set(handles.ed_kaiser, 'Visible', 'off');
  set(handles.ed_rp,     'Visible', 'off');
  set(handles.ed_rs,     'Visible', 'off');
  set(handles.lbl_stability, 'Visible', 'off');

  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();
end
