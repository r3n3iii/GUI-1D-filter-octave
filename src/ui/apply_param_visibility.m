%% DESCRIPTION
%  Shows/hides parameter widgets based on current filter type and method.
%% INPUTS
%  handles  struct — application state
%% OUTPUTS
%  none

function apply_param_visibility(handles)
  is_fir = strcmp(handles.filter_type, 'FIR');
  method = handles.design_method;

  % Window controls — FIR window method only
  show_window = is_fir && strcmp(method, 'window');
  set(handles.lbl_window, 'Visible', onoff(show_window));
  set(handles.dd_window,  'Visible', onoff(show_window));

  % Kaiser beta — only when window method + Kaiser selected
  is_kaiser = show_window && (get(handles.dd_window, 'Value') == 4);
  set(handles.lbl_kaiser, 'Visible', onoff(is_kaiser));
  set(handles.ed_kaiser,  'Visible', onoff(is_kaiser));

  % Rp — Chebyshev I and Elliptic
  show_rp = ~is_fir && any(strcmp(method, {'cheby1', 'ellip'}));
  set(handles.lbl_rp, 'Visible', onoff(show_rp));
  set(handles.ed_rp,  'Visible', onoff(show_rp));

  % Rs — Chebyshev II and Elliptic
  show_rs = ~is_fir && any(strcmp(method, {'cheby2', 'ellip'}));
  set(handles.lbl_rs, 'Visible', onoff(show_rs));
  set(handles.ed_rs,  'Visible', onoff(show_rs));

  % Cutoff label hint — two values needed for bandpass/bandstop
  band_idx  = get(handles.dd_band, 'Value');
  is_2band  = band_idx >= 3;
  if is_2band
    set(handles.lbl_wn, 'String', 'Cutoff Hz [f1 f2]:');
  else
    set(handles.lbl_wn, 'String', 'Cutoff (Hz):');
  end
end

function s = onoff(val)
  if val; s = 'on'; else; s = 'off'; end
end
