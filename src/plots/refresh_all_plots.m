%% DESCRIPTION
%  Refreshes the active plot or coefficient table using current handles state.
%% INPUTS
%  handles  struct — application state (b, a, Fs, active_plot, ax_main, tbl_coeffs)
%% OUTPUTS
%  none

function refresh_all_plots(handles)
  if strcmp(handles.active_plot, 'coefficients')
    set(handles.ax_main,       'Visible', 'off');
    set(handles.tbl_coeffs,    'Visible', 'on');
    set(handles.lbl_structure, 'Visible', 'on');
    set(handles.dd_structure,  'Visible', 'on');
    update_coeff_table(handles);
  else
    set(handles.tbl_coeffs,    'Visible', 'off');
    set(handles.lbl_structure, 'Visible', 'off');
    set(handles.dd_structure,  'Visible', 'off');
    set(handles.ax_main,       'Visible', 'on');
    render_plot(handles.ax_main, handles.active_plot, handles.b, handles.a, handles.Fs, handles.phase_wrapped, handles.freq_unit);
  end
end
