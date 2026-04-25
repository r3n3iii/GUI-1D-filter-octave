%% DESCRIPTION
%  Callback: Wn edit box changed. Parses and stores the value in handles.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_freq_changed(hobj, evt)
  handles = guidata(hobj);
  val = str2num(get(hobj, 'String'));
  if isempty(val) || any(val <= 0) || any(val >= 1)
    set(hobj, 'String', num2str(handles.Wn));
    return;
  end
  handles.Wn = val;
  guidata(hobj, handles);
end
