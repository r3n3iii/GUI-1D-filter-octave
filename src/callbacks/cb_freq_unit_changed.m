%% DESCRIPTION
%  Callback: frequency unit dropdown changed. Converts all displayed frequency
%  values to the new unit without changing the underlying filter (no redesign).
%% INPUTS
%  hobj  handle — source dropdown
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_freq_unit_changed(hobj, evt)
  handles = guidata(hobj);

  UNIT_KEYS   = {'Hz', 'kHz', 'MHz', 'GHz', 'Normalized'};
  UNIT_SCALES = [1, 1e3, 1e6, 1e9, NaN];

  new_idx  = get(hobj, 'Value');
  new_unit = UNIT_KEYS{new_idx};

  % Internal source of truth: normalized values + Fs in Hz
  Fs_hz  = handles.Fs;
  Nyq    = Fs_hz / 2;

  % Convert all frequency fields
  if strcmp(new_unit, 'Normalized')
    % Display normalized (Wn, 0-1 where 1 = Nyquist) directly
    wn = handles.Wn;
    if numel(wn) > 1
      set(handles.ed_wn, 'String', mat2str(wn, 4));
    else
      set(handles.ed_wn, 'String', num2str(wn, 4));
    end
    set(handles.ed_fpass,  'String', num2str(handles.fpass,  4));
    set(handles.ed_fstop,  'String', num2str(handles.fstop,  4));
    set(handles.ed_fpass2, 'String', num2str(handles.fpass2, 4));
    set(handles.ed_fstop2, 'String', num2str(handles.fstop2, 4));
  else
    scale      = UNIT_SCALES(new_idx);
    cutoff_hz  = handles.Wn    * Nyq;
    fpass_hz   = handles.fpass  * Nyq;
    fstop_hz   = handles.fstop  * Nyq;
    fpass2_hz  = handles.fpass2 * Nyq;
    fstop2_hz  = handles.fstop2 * Nyq;

    if numel(cutoff_hz) > 1
      set(handles.ed_wn, 'String', mat2str(cutoff_hz / scale, 6));
    else
      set(handles.ed_wn, 'String', num2str(cutoff_hz / scale, 6));
    end
    set(handles.ed_fs,     'String', num2str(Fs_hz    / scale, 6));
    set(handles.ed_fpass,  'String', num2str(fpass_hz  / scale, 6));
    set(handles.ed_fstop,  'String', num2str(fstop_hz  / scale, 6));
    set(handles.ed_fpass2, 'String', num2str(fpass2_hz / scale, 6));
    set(handles.ed_fstop2, 'String', num2str(fstop2_hz / scale, 6));
  end

  handles.freq_unit = new_unit;
  guidata(hobj, handles);
  apply_param_visibility(handles);
end
