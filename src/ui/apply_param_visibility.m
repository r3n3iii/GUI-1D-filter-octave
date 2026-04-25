%% DESCRIPTION
%  Shows/hides parameter widgets based on current filter type, method, and freq unit.
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

  % Fs row — hidden in Normalized mode
  is_norm = strcmp(handles.freq_unit, 'Normalized');
  set(handles.lbl_fs, 'Visible', onoff(~is_norm));
  set(handles.ed_fs,  'Visible', onoff(~is_norm));

  % Cutoff and Fs labels — reflect current unit
  band_idx = get(handles.dd_band, 'Value');
  is_2band = band_idx >= 3;

  if is_norm
    unit_str = '(0\x20131)';
    fs_str   = 'Fs (Hz):';
  else
    UNIT_LABELS = {'Hz', 'kHz', 'MHz', 'GHz'};
    unit_idx = get(handles.dd_freq_unit, 'Value');
    unit_str = UNIT_LABELS{unit_idx};
    fs_str   = sprintf('Fs (%s):', unit_str);
    set(handles.lbl_fs, 'String', fs_str);
  end

  if is_norm
    if is_2band
      set(handles.lbl_wn, 'String', 'Cutoff 0-1 [f1 f2]:');
    else
      set(handles.lbl_wn, 'String', 'Cutoff (0-1):');
    end
  else
    if is_2band
      set(handles.lbl_wn, 'String', sprintf('Cutoff %s [f1 f2]:', unit_str));
    else
      set(handles.lbl_wn, 'String', sprintf('Cutoff (%s):', unit_str));
    end
    set(handles.lbl_fs, 'String', fs_str);
  end
end

function s = onoff(val)
  if val; s = 'on'; else; s = 'off'; end
end
