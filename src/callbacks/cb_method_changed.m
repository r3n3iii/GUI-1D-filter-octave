%% DESCRIPTION
%  Callback: design method dropdown changed. Updates method key and visibility.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_method_changed(hobj, evt)
  handles = guidata(hobj);

  idx = get(handles.dd_method, 'Value');
  if strcmp(handles.filter_type, 'FIR')
    keys = {'window', 'ls', 'pm'};
  else
    keys = {'butter', 'cheby1', 'cheby2', 'ellip'};
  end
  handles.design_method = keys{idx};

  guidata(hobj, handles);
  apply_param_visibility(handles);
end
