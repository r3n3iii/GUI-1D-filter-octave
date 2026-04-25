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
  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();
end

% --- helpers ---------------------------------------------------------------

function handles = read_ui_params(handles)
  BAND_KEYS = {'low', 'high', 'bandpass', 'stop'};
  WIN_KEYS  = {'hamming', 'hann', 'blackman', 'kaiser', 'rectangular'};

  handles.filter_order = max(1, round(str2double(get(handles.ed_order, 'String'))));
  handles.Wn           = str2num(get(handles.ed_wn, 'String'));
  handles.Fs           = str2double(get(handles.ed_fs, 'String'));
  handles.band_type    = BAND_KEYS{get(handles.dd_band, 'Value')};
  handles.window_type  = WIN_KEYS{get(handles.dd_window, 'Value')};
  handles.kaiser_beta  = str2double(get(handles.ed_kaiser, 'String'));
  handles.Rp           = str2double(get(handles.ed_rp, 'String'));
  handles.Rs           = str2double(get(handles.ed_rs, 'String'));
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
    case 'ls';      [b, a] = design_fir_ls(params);
    case 'pm';      [b, a] = design_fir_pm(params);
    case 'butter';  [b, a] = design_iir_butter(params);
    case 'cheby1';  [b, a] = design_iir_cheby1(params);
    case 'cheby2';  [b, a] = design_iir_cheby2(params);
    case 'ellip';   [b, a] = design_iir_ellip(params);
    otherwise;      error('Unknown design method: %s', handles.design_method);
  end
end
