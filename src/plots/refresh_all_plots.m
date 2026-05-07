%% DESCRIPTION
%  Refreshes the active plot or coefficient table using current handles state.
%% INPUTS
%  handles  struct — application state (b, a, Fs, active_plot, ax_main, tbl_coeffs)
%% OUTPUTS
%  none

function refresh_all_plots(handles)
  if strcmp(handles.active_plot, 'coefficients')
    cla(handles.ax_main);
    title(handles.ax_main,  '');
    xlabel(handles.ax_main, '');
    ylabel(handles.ax_main, '');
    set(handles.ax_main,       'Visible', 'off');
    set(handles.tbl_info,      'Visible', 'off');
    set(handles.tbl_coeffs,    'Visible', 'on');
    set(handles.lbl_structure, 'Visible', 'on');
    set(handles.dd_structure,  'Visible', 'on');
    set(handles.btn_mag_scale,  'Visible', 'off');
    set(handles.btn_phase_wrap, 'Visible', 'off');
    update_coeff_table(handles);

  elseif strcmp(handles.active_plot, 'info')
    cla(handles.ax_main);
    title(handles.ax_main,  '');
    xlabel(handles.ax_main, '');
    ylabel(handles.ax_main, '');
    set(handles.ax_main,       'Visible', 'off');
    set(handles.tbl_coeffs,    'Visible', 'off');
    set(handles.lbl_structure, 'Visible', 'off');
    set(handles.dd_structure,  'Visible', 'off');
    set(handles.btn_mag_scale,  'Visible', 'off');
    set(handles.btn_phase_wrap, 'Visible', 'off');
    struct_idx = get(handles.dd_structure, 'Value');
    rows = compute_filter_info(handles.b, handles.a, handles.Fs, struct_idx, handles.freq_unit);
    set(handles.tbl_info, 'Data', rows, 'Visible', 'on');

  else
    set(handles.tbl_coeffs,    'Visible', 'off');
    set(handles.tbl_info,      'Visible', 'off');
    set(handles.lbl_structure, 'Visible', 'off');
    set(handles.dd_structure,  'Visible', 'off');
    set(handles.ax_main,       'Visible', 'on');
    if strcmp(handles.active_plot, 'magnitude')
      set(handles.btn_mag_scale,  'Visible', 'on');
      set(handles.btn_phase_wrap, 'Visible', 'off');
    elseif strcmp(handles.active_plot, 'phase')
      set(handles.btn_mag_scale,  'Visible', 'off');
      set(handles.btn_phase_wrap, 'Visible', 'on');
    else
      set(handles.btn_mag_scale,  'Visible', 'off');
      set(handles.btn_phase_wrap, 'Visible', 'off');
    end
    render_plot(handles.ax_main, handles.active_plot, handles.b, handles.a, handles.Fs, handles.phase_wrapped, handles.freq_unit, handles.mag_linear);
  end
end
