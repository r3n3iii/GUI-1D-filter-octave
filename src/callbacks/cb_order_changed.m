%% DESCRIPTION
%  Callback: order edit box changed. Parses and stores the value in handles.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_order_changed(hobj, evt)
  handles = guidata(hobj);
  val = round(str2double(get(hobj, 'String')));
  if isnan(val) || val < 1
    set(hobj, 'String', num2str(handles.filter_order));
    return;
  end
  handles.filter_order = val;
  guidata(hobj, handles);
end
