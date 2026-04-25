%% DESCRIPTION
%  Callback: cutoff frequency edit box changed. Validates Hz range and updates handles.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_freq_changed(hobj, evt)
  handles  = guidata(hobj);
  nyquist  = handles.Fs / 2;
  val      = str2num(get(hobj, 'String'));
  if isempty(val) || any(val <= 0) || any(val >= nyquist)
    set(hobj, 'String', num2str(handles.Wn * nyquist));
    return;
  end
  handles.Wn = val / nyquist;
  guidata(hobj, handles);
end
