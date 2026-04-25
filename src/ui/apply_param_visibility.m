%% DESCRIPTION
%  Shows/hides parameter widgets based on current filter type and method.
%% INPUTS
%  handles  struct — application state
%% OUTPUTS
%  none

function apply_param_visibility(handles)
  is_fir = strcmp(handles.filter_type, 'FIR');
  method = handles.design_method;

  show_window = is_fir && strcmp(method, 'window');
  set(handles.dd_window, 'Visible', onoff(show_window));

  is_kaiser = show_window && (get(handles.dd_window, 'Value') == 4);
  set(handles.ed_kaiser, 'Visible', onoff(is_kaiser));

  show_rp = ~is_fir && any(strcmp(method, {'cheby1', 'ellip'}));
  set(handles.ed_rp, 'Visible', onoff(show_rp));

  show_rs = ~is_fir && any(strcmp(method, {'cheby2', 'ellip'}));
  set(handles.ed_rs, 'Visible', onoff(show_rs));
end

function s = onoff(val)
  if val; s = 'on'; else; s = 'off'; end
end
