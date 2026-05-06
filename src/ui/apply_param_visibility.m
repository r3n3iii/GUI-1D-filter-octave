%% DESCRIPTION
%  Shows/hides parameter widgets based on filter type, design method, band, and freq unit.
%  Also updates field labels to reflect the current unit and band semantics.
%% INPUTS
%  handles  struct — application state
%% OUTPUTS
%  none

function apply_param_visibility(handles)
  is_fir   = strcmp(handles.filter_type, 'FIR');
  method   = handles.design_method;
  is_ls_pm = any(strcmp(method, {'ls', 'pm'}));
  is_norm  = strcmp(handles.freq_unit, 'Normalized');

  BAND_KEYS = {'low', 'high', 'bandpass', 'stop'};
  band_type = BAND_KEYS{get(handles.dd_band, 'Value')};
  is_2band  = any(strcmp(band_type, {'bandpass', 'stop'}));

  % -------------------------------------------------------
  % Frequency section
  % -------------------------------------------------------

  % Fs row — hidden in Normalized mode
  set(handles.lbl_fs, 'Visible', onoff(~is_norm));
  set(handles.ed_fs,  'Visible', onoff(~is_norm));

  % Generic cutoff — all methods except LS/PM
  set(handles.lbl_wn, 'Visible', onoff(~is_ls_pm));
  set(handles.ed_wn,  'Visible', onoff(~is_ls_pm));

  % LS/PM 1st and 2nd band-edges — always shown for LS/PM
  set(handles.lbl_fpass, 'Visible', onoff(is_ls_pm));
  set(handles.ed_fpass,  'Visible', onoff(is_ls_pm));
  set(handles.lbl_fstop, 'Visible', onoff(is_ls_pm));
  set(handles.ed_fstop,  'Visible', onoff(is_ls_pm));

  % LS/PM 3rd and 4th band-edges — 2-band only
  set(handles.lbl_fpass2, 'Visible', onoff(is_ls_pm && is_2band));
  set(handles.ed_fpass2,  'Visible', onoff(is_ls_pm && is_2band));
  set(handles.lbl_fstop2, 'Visible', onoff(is_ls_pm && is_2band));
  set(handles.ed_fstop2,  'Visible', onoff(is_ls_pm && is_2band));

  % -------------------------------------------------------
  % Magnitude section
  % -------------------------------------------------------

  % Window controls — FIR window method only
  show_window = is_fir && strcmp(method, 'window');
  set(handles.lbl_window, 'Visible', onoff(show_window));
  set(handles.dd_window,  'Visible', onoff(show_window));

  % Kaiser beta — window method + Kaiser selected
  is_kaiser = show_window && (get(handles.dd_window, 'Value') == 4);
  set(handles.lbl_kaiser, 'Visible', onoff(is_kaiser));
  set(handles.ed_kaiser,  'Visible', onoff(is_kaiser));

  % Rp — cheby1 and ellip
  show_rp = ~is_fir && any(strcmp(method, {'cheby1', 'ellip'}));
  set(handles.lbl_rp, 'Visible', onoff(show_rp));
  set(handles.ed_rp,  'Visible', onoff(show_rp));

  % Rs — cheby2 and ellip
  show_rs = ~is_fir && any(strcmp(method, {'cheby2', 'ellip'}));
  set(handles.lbl_rs, 'Visible', onoff(show_rs));
  set(handles.ed_rs,  'Visible', onoff(show_rs));

  % Wpass / Wstop — LS and PM
  set(handles.lbl_wpass, 'Visible', onoff(is_ls_pm));
  set(handles.ed_wpass,  'Visible', onoff(is_ls_pm));
  set(handles.lbl_wstop, 'Visible', onoff(is_ls_pm));
  set(handles.ed_wstop,  'Visible', onoff(is_ls_pm));

  % Density factor — PM only
  is_pm = strcmp(method, 'pm');
  set(handles.lbl_density, 'Visible', onoff(is_pm));
  set(handles.ed_density,  'Visible', onoff(is_pm));

  % -------------------------------------------------------
  % Update label strings based on freq unit + band type
  % -------------------------------------------------------

  if is_norm
    unit_str = '(0-1)';
  else
    UNIT_LABELS = {'Hz', 'kHz', 'MHz', 'GHz'};
    unit_idx = get(handles.dd_freq_unit, 'Value');
    unit_str = UNIT_LABELS{unit_idx};
  end

  % Fs label
  set(handles.lbl_fs, 'String', sprintf('Fs (%s):', unit_str));

  % Generic cutoff label
  if is_2band
    set(handles.lbl_wn, 'String', sprintf('Cutoff %s [f1 f2]:', unit_str));
  else
    set(handles.lbl_wn, 'String', sprintf('Cutoff (%s):', unit_str));
  end

  % LS/PM band-edge labels — follow MATLAB convention:
  %   lowpass:  Fpass | Fstop
  %   highpass: Fstop | Fpass
  %   bandpass: Fstop1 | Fpass1 | Fpass2 | Fstop2
  %   bandstop: Fpass1 | Fstop1 | Fstop2 | Fpass2
  [n1, n2, n3, n4] = band_edge_names(band_type);
  set(handles.lbl_fpass,  'String', sprintf('%s (%s):', n1, unit_str));
  set(handles.lbl_fstop,  'String', sprintf('%s (%s):', n2, unit_str));
  set(handles.lbl_fpass2, 'String', sprintf('%s (%s):', n3, unit_str));
  set(handles.lbl_fstop2, 'String', sprintf('%s (%s):', n4, unit_str));
end

% Returns the four semantic names for the band edges, low-to-high order.
function [n1, n2, n3, n4] = band_edge_names(band_type)
  switch band_type
    case 'low'
      n1 = 'Fpass'; n2 = 'Fstop';  n3 = '';      n4 = '';
    case 'high'
      n1 = 'Fstop'; n2 = 'Fpass';  n3 = '';      n4 = '';
    case 'bandpass'
      n1 = 'Fstop1'; n2 = 'Fpass1'; n3 = 'Fpass2'; n4 = 'Fstop2';
    case 'stop'
      n1 = 'Fpass1'; n2 = 'Fstop1'; n3 = 'Fstop2'; n4 = 'Fpass2';
    otherwise
      n1 = 'F1'; n2 = 'F2'; n3 = 'F3'; n4 = 'F4';
  end
end

function s = onoff(val)
  if val; s = 'on'; else; s = 'off'; end
end
