%% DESCRIPTION
%  Refreshes all four visualization panels using current handles state.
%% INPUTS
%  handles  struct — application state (b, a, Fs, axes handles, table handle)
%% OUTPUTS
%  none

function refresh_all_plots(handles)
  plot_magnitude(handles.ax_mag, handles.b, handles.a, handles.Fs);
  plot_polezero(handles.ax_pz,  handles.b, handles.a);
  N = max(64, numel(handles.b) + 20);
  plot_impulse(handles.ax_imp,  handles.b, handles.a, N);
  if isfield(handles, 'tbl_coeffs')
    update_coeff_table(handles);
  end
end
