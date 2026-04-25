%% DESCRIPTION
%  Callback: toggles the phase plot between wrapped and unwrapped display.
%% INPUTS
%  hobj  handle — source button
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_phase_wrap_toggle(hobj, evt)
  handles = guidata(hobj);
  handles.phase_wrapped = ~handles.phase_wrapped;

  if handles.phase_wrapped
    set(hobj, 'String', 'Wrapped', ...
      'BackgroundColor', [0.30 0.60 1.00], 'ForegroundColor', [1 1 1]);
  else
    set(hobj, 'String', 'Unwrapped', ...
      'BackgroundColor', [0.94 0.94 0.94], 'ForegroundColor', [0 0 0]);
  end

  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();
end
