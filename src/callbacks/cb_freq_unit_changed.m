%% DESCRIPTION
%  Callback: frequency unit dropdown changed. Converts displayed values to the
%  new unit without changing the underlying filter (no redesign triggered).
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

  % Use the internally stored Hz values as source of truth
  Fs_hz      = handles.Fs;
  cutoff_hz  = handles.Wn * (Fs_hz / 2);

  if strcmp(new_unit, 'Normalized')
    % Display Wn directly; hide Fs row
    wn_vals = handles.Wn;
    if numel(wn_vals) > 1
      set(handles.ed_wn, 'String', mat2str(wn_vals, 4));
    else
      set(handles.ed_wn, 'String', num2str(wn_vals, 4));
    end
  else
    scale = UNIT_SCALES(new_idx);
    if numel(cutoff_hz) > 1
      set(handles.ed_wn, 'String', mat2str(cutoff_hz / scale, 6));
    else
      set(handles.ed_wn, 'String', num2str(cutoff_hz / scale, 6));
    end
    set(handles.ed_fs, 'String', num2str(Fs_hz / scale, 6));
  end

  handles.freq_unit = new_unit;
  guidata(hobj, handles);
  apply_param_visibility(handles);
end
