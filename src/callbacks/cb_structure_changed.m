%% DESCRIPTION
%  Callback: coefficient structure dropdown changed. Re-renders table if active.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_structure_changed(hobj, evt)
  handles = guidata(hobj);
  if strcmp(handles.active_plot, 'coefficients')
    update_coeff_table(handles);
  end
end
