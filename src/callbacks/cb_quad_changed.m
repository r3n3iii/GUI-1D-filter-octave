%% DESCRIPTION
%  Callback: a quadrant plot-selector dropdown changed. Re-renders all quadrants.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_quad_changed(hobj, evt)
  handles = guidata(hobj);
  refresh_all_plots(handles);
  drawnow();
end
