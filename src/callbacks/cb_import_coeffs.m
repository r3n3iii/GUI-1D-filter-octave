%% DESCRIPTION
%  Callback: opens a modal dialog to import or edit filter coefficients (b, a).
%  Pre-fills the dialog with the current filter. On Apply, updates the main
%  app state and refreshes all plots.
%% INPUTS
%  hobj  handle — source widget (Import button)
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_import_coeffs(hobj, evt)
  handles = guidata(hobj);

  UNIT_STRS   = {'Hz', 'kHz', 'MHz', 'GHz', 'Normalized'};
  UNIT_SCALES = [1, 1e3, 1e6, 1e9];

  % Pre-format current b / a as row vectors
  b_str = mat2str(handles.b(:)', 8);
  a_str = mat2str(handles.a(:)', 8);

  % Determine current unit index
  cur_unit_idx = find(strcmp(UNIT_STRS, handles.freq_unit));
  if isempty(cur_unit_idx)
    cur_unit_idx = 1;
  end
  is_norm_init = (cur_unit_idx == 5);

  % Fs displayed in current unit
  if is_norm_init
    fs_display = handles.Fs;
  else
    fs_display = handles.Fs / UNIT_SCALES(cur_unit_idx);
  end

  % ---- Build dialog figure -------------------------------------------------
  dlg = figure( ...
    'Name',        'Import / Edit Coefficients', ...
    'NumberTitle', 'off', ...
    'MenuBar',     'none', ...
    'ToolBar',     'none', ...
    'WindowStyle', 'modal', ...
    'Position',    [300 300 430 235], ...
    'Resize',      'off');

  % Numerator b
  uicontrol(dlg, 'Style', 'text', ...
    'Position', [10 200 110 20], ...
    'String', 'Numerator b:', 'HorizontalAlignment', 'left');
  ed_b = uicontrol(dlg, 'Style', 'edit', ...
    'Position', [125 200 295 22], 'String', b_str);

  % Denominator a
  uicontrol(dlg, 'Style', 'text', ...
    'Position', [10 168 110 20], ...
    'String', 'Denominator a:', 'HorizontalAlignment', 'left');
  ed_a = uicontrol(dlg, 'Style', 'edit', ...
    'Position', [125 168 295 22], 'String', a_str);

  % Freq unit
  uicontrol(dlg, 'Style', 'text', ...
    'Position', [10 130 110 20], ...
    'String', 'Freq Unit:', 'HorizontalAlignment', 'left');
  dd_unit = uicontrol(dlg, 'Style', 'popupmenu', ...
    'Position', [125 130 120 22], ...
    'String', UNIT_STRS, 'Value', cur_unit_idx);

  % Fs
  uicontrol(dlg, 'Style', 'text', ...
    'Position', [10 95 110 20], ...
    'String', 'Fs:', 'HorizontalAlignment', 'left');
  ed_fs_dlg = uicontrol(dlg, 'Style', 'edit', ...
    'Position', [125 95 120 22], ...
    'String', num2str(fs_display), ...
    'Enable', onoff(~is_norm_init));

  % Buttons
  btn_cancel = uicontrol(dlg, 'Style', 'pushbutton', ...
    'Position', [225 20 90 30], 'String', 'Cancel');
  btn_apply = uicontrol(dlg, 'Style', 'pushbutton', ...
    'Position', [325 20 90 30], 'String', 'Apply', ...
    'FontWeight', 'bold');

  % Shared dialog state
  dlg_state.result = [];
  guidata(dlg, dlg_state);

  % Wire callbacks
  set(dd_unit,    'Callback', @cb_unit_changed);
  set(btn_cancel, 'Callback', @(h, e) uiresume(dlg));
  set(btn_apply,  'Callback', @cb_apply);

  uiwait(dlg);

  % --- Dialog closed --------------------------------------------------------
  if ~ishandle(dlg); return; end
  dlg_state = guidata(dlg);
  close(dlg);

  if isempty(dlg_state.result); return; end   % Cancel or X

  % Apply result to main app state
  r = dlg_state.result;
  handles = guidata(hobj);
  handles.b         = r.b;
  handles.a         = r.a;
  handles.Fs        = r.Fs;
  handles.freq_unit = r.freq_unit;

  % Sync main panel freq unit dropdown + Fs field
  unit_idx = find(strcmp(UNIT_STRS, r.freq_unit));
  if isempty(unit_idx); unit_idx = 1; end
  set(handles.dd_freq_unit, 'Value', unit_idx);
  if unit_idx < 5
    set(handles.ed_fs, 'String', num2str(r.Fs / UNIT_SCALES(unit_idx)));
  end
  apply_param_visibility(handles);

  % Stability check
  poles = roots(handles.a);
  if any(abs(poles) > 1)
    set(handles.lbl_stability, ...
      'String', 'WARNING: Unstable filter (poles outside unit circle)', ...
      'Visible', 'on');
  else
    set(handles.lbl_stability, 'Visible', 'off');
  end

  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();

  % ---- Nested callbacks ----------------------------------------------------

  function cb_unit_changed(h, e)
    idx    = get(dd_unit, 'Value');
    is_nor = (idx == 5);
    set(ed_fs_dlg, 'Enable', onoff(~is_nor));
  end

  function cb_apply(h, e)
    b_val = str2num(get(ed_b, 'String'));   %#ok<ST2NM>
    a_val = str2num(get(ed_a, 'String'));   %#ok<ST2NM>

    if isempty(b_val)
      errordlg('Invalid numerator b — enter a numeric vector, e.g. [1 0.5 0.25]', ...
        'Input Error', 'modal');
      return;
    end
    if isempty(a_val)
      errordlg('Invalid denominator a — enter a numeric vector, e.g. [1 -0.9]', ...
        'Input Error', 'modal');
      return;
    end

    unit_idx  = get(dd_unit, 'Value');
    freq_unit = UNIT_STRS{unit_idx};

    if unit_idx == 5   % Normalized
      Fs_out = handles.Fs;   % keep existing Fs; it won't appear on x-axis
    else
      Fs_disp = str2double(get(ed_fs_dlg, 'String'));
      if isnan(Fs_disp) || Fs_disp <= 0
        errordlg('Fs must be a positive number.', 'Input Error', 'modal');
        return;
      end
      Fs_out = Fs_disp * UNIT_SCALES(unit_idx);
    end

    r.b         = b_val(:)';
    r.a         = a_val(:)';
    r.Fs        = Fs_out;
    r.freq_unit = freq_unit;

    dlg_state.result = r;
    guidata(dlg, dlg_state);
    uiresume(dlg);
  end

  function s = onoff(val)
    if val; s = 'on'; else; s = 'off'; end
  end
end
