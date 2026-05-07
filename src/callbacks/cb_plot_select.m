%% DESCRIPTION
%  Callback: a plot-selector button was clicked. Updates active plot and redraws.
%% INPUTS
%  hobj  handle — source button
%  key   string — plot type key selected
%% OUTPUTS
%  none

function cb_plot_select(hobj, key)
  handles = guidata(hobj);
  handles.active_plot = key;

  % Highlight the active button, reset others
  PLOT_KEYS = {'magnitude','phase','phase_delay','group_delay', ...
               'polezero','impulse','coefficients','info'};
  for i = 1:numel(handles.btns_plot)
    if strcmp(PLOT_KEYS{i}, key)
      set(handles.btns_plot(i), 'BackgroundColor', [0.30 0.60 1.00]);
      set(handles.btns_plot(i), 'ForegroundColor', [1 1 1]);
    else
      set(handles.btns_plot(i), 'BackgroundColor', [0.94 0.94 0.94]);
      set(handles.btns_plot(i), 'ForegroundColor', [0 0 0]);
    end
  end

  if strcmp(key, 'phase')
    set(handles.btn_phase_wrap, 'Visible', 'on');
  else
    set(handles.btn_phase_wrap, 'Visible', 'off');
  end

  guidata(hobj, handles);
  refresh_all_plots(handles);
  drawnow();
end
