%% DESCRIPTION
%  Callback: toggles the magnitude plot between dB and linear scale.
%% INPUTS
%  hobj  handle — source button
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_mag_scale_toggle(hobj, evt)
  handles = guidata(hobj);
  handles.mag_linear = ~handles.mag_linear;

  if handles.mag_linear
    set(hobj, 'String', 'Linear', ...
      'BackgroundColor', [0.94 0.94 0.94], 'ForegroundColor', [0 0 0]);
  else
    set(hobj, 'String', 'dB', ...
      'BackgroundColor', [0.30 0.60 1.00], 'ForegroundColor', [1 1 1]);
  end

  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();
end
