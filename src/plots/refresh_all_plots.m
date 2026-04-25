%% DESCRIPTION
%  Refreshes all visualization panels using current handles state.
%% INPUTS
%  handles  struct — application state (b, a, Fs, axes, dropdowns, table)
%% OUTPUTS
%  none

function refresh_all_plots(handles)
  PLOT_KEYS = {'magnitude', 'phase', 'group_delay', 'polezero', 'impulse'};

  for q = 1:3
    ax_f = sprintf('ax_q%d', q);
    dd_f = sprintf('dd_q%d', q);
    idx  = get(handles.(dd_f), 'Value');
    render_quadrant(handles.(ax_f), PLOT_KEYS{idx}, handles.b, handles.a, handles.Fs);
  end

  if isfield(handles, 'tbl_coeffs')
    update_coeff_table(handles);
  end
end
