%% DESCRIPTION
%  Callback: "Design Filter" button pressed. Validates, designs, and refreshes.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_design_clicked(hobj, evt)
  handles = guidata(hobj);
  handles = read_ui_params(handles);

  result = validate_params(handles);
  if ~result.ok
    errordlg(result.message, 'Invalid Parameters', 'modal');
    return;
  end

  try
    [b, a] = call_design(handles);
  catch e
    errordlg(e.message, 'Design Error', 'modal');
    return;
  end

  handles.b = b;
  handles.a = a;

  poles = roots(a);
  if any(abs(poles) > 1)
    set(handles.lbl_stability, 'String', 'WARNING: Unstable filter (poles outside unit circle)', 'Visible', 'on');
  else
    set(handles.lbl_stability, 'Visible', 'off');
  end

  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();
end

% --- helpers ---------------------------------------------------------------

function handles = read_ui_params(handles)
  BAND_KEYS   = {'low', 'high', 'bandpass', 'stop'};
  WIN_KEYS    = {'hamming', 'hann', 'blackman', 'kaiser', 'rectangular'};
  UNIT_SCALES = [1, 1e3, 1e6, 1e9];   % Hz, kHz, MHz, GHz

  handles.filter_order = max(1, round(str2double(get(handles.ed_order, 'String'))));
  handles.band_type    = BAND_KEYS{get(handles.dd_band, 'Value')};
  handles.window_type  = WIN_KEYS{get(handles.dd_window, 'Value')};
  handles.kaiser_beta  = str2double(get(handles.ed_kaiser, 'String'));
  handles.Rp           = str2double(get(handles.ed_rp,     'String'));
  handles.Rs           = str2double(get(handles.ed_rs,     'String'));
  handles.Wpass          = str2double(get(handles.ed_wpass,   'String'));
  handles.Wstop          = str2double(get(handles.ed_wstop,   'String'));
  handles.density_factor = max(16, round(str2double(get(handles.ed_density, 'String'))));

  unit_idx = get(handles.dd_freq_unit, 'Value');
  if unit_idx == 5   % Normalized
    handles.Wn    = str2num(get(handles.ed_wn,    'String'));   %#ok<ST2NM>
    handles.fpass  = str2double(get(handles.ed_fpass,  'String'));
    handles.fstop  = str2double(get(handles.ed_fstop,  'String'));
    handles.fpass2 = str2double(get(handles.ed_fpass2, 'String'));
    handles.fstop2 = str2double(get(handles.ed_fstop2, 'String'));
  else
    scale         = UNIT_SCALES(unit_idx);
    handles.Fs    = str2double(get(handles.ed_fs, 'String')) * scale;
    cutoff_hz     = str2num(get(handles.ed_wn, 'String')) * scale;   %#ok<ST2NM>
    Nyq           = handles.Fs / 2;
    handles.Wn    = cutoff_hz / Nyq;
    handles.fpass  = str2double(get(handles.ed_fpass,  'String')) * scale / Nyq;
    handles.fstop  = str2double(get(handles.ed_fstop,  'String')) * scale / Nyq;
    handles.fpass2 = str2double(get(handles.ed_fpass2, 'String')) * scale / Nyq;
    handles.fstop2 = str2double(get(handles.ed_fstop2, 'String')) * scale / Nyq;
  end
end

function [b, a] = call_design(handles)
  params.order       = handles.filter_order;
  params.Wn          = handles.Wn;
  params.band        = handles.band_type;
  params.Rp          = handles.Rp;
  params.Rs          = handles.Rs;
  params.window      = handles.window_type;
  params.kaiser_beta = handles.kaiser_beta;

  switch handles.design_method
    case 'window';  [b, a] = design_fir_window(params);
    case 'ls';      [b, a] = design_fir_ls(build_band_params(handles));
    case 'pm';      [b, a] = design_fir_pm(build_band_params(handles), handles.density_factor);
    case 'butter';  [b, a] = design_iir_butter(params);
    case 'cheby1';  [b, a] = design_iir_cheby1(params);
    case 'cheby2';  [b, a] = design_iir_cheby2(params);
    case 'ellip';   [b, a] = design_iir_ellip(params);
    otherwise;      error('Unknown design method: %s', handles.design_method);
  end
end

% Builds F/A/W band vectors for firls / remez from the explicit band-edge fields.
% F is normalized [0,1] where 1 = Nyquist.  F must be monotonically non-decreasing.
%
% Band-edge semantics (MATLAB convention, low-to-high):
%   lowpass:  fpass  | fstop
%   highpass: fstop  | fpass      (fstop < fpass)
%   bandpass: fstop1 | fpass1 | fpass2 | fstop2
%   bandstop: fpass1 | fstop1 | fstop2 | fpass2
function p = build_band_params(handles)
  p.order = handles.filter_order;
  f1 = handles.fpass;
  f2 = handles.fstop;
  f3 = handles.fpass2;
  f4 = handles.fstop2;
  Wp = handles.Wpass;
  Ws = handles.Wstop;

  switch handles.band_type
    case 'low'
      p.F = [0, f1, f2, 1];
      p.A = [1, 1,  0, 0];
      p.W = [Wp, Ws];
    case 'high'
      p.F = [0, f1, f2, 1];
      p.A = [0, 0,  1, 1];
      p.W = [Ws, Wp];
    case 'bandpass'
      p.F = [0, f1, f2, f3, f4, 1];
      p.A = [0, 0,  1,  1,  0, 0];
      p.W = [Ws, Wp, Ws];
    case 'stop'
      p.F = [0, f1, f2, f3, f4, 1];
      p.A = [1, 1,  0,  0,  1, 1];
      p.W = [Wp, Ws, Wp];
    otherwise
      error('build_band_params: unknown band type ''%s''', handles.band_type);
  end
end
