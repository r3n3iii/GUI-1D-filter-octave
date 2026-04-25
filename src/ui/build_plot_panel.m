%% DESCRIPTION
%  Creates the right panel: four axes and the coefficient table.
%% INPUTS
%  parent   handle — parent container
%% OUTPUTS
%  handles  struct — axes handles (ax_mag, ax_pz, ax_imp) and table handle

function handles = build_plot_panel(parent)
  handles = struct();
  TITLE_SIZE = 11;

  handles.ax_mag = axes('Parent', parent, ...
    'Units', 'normalized', 'Position', [0.05 0.55 0.42 0.38]);
  th = title(handles.ax_mag, 'Magnitude Response');
  set(th, 'FontSize', TITLE_SIZE);
  xlabel(handles.ax_mag, 'Frequency');
  ylabel(handles.ax_mag, 'Magnitude (dB)');
  grid(handles.ax_mag, 'on');

  handles.ax_pz = axes('Parent', parent, ...
    'Units', 'normalized', 'Position', [0.55 0.55 0.42 0.38]);
  th = title(handles.ax_pz, 'Pole-Zero Plot');
  set(th, 'FontSize', TITLE_SIZE);
  axis(handles.ax_pz, 'equal');
  grid(handles.ax_pz, 'on');

  handles.ax_imp = axes('Parent', parent, ...
    'Units', 'normalized', 'Position', [0.05 0.05 0.42 0.38]);
  th = title(handles.ax_imp, 'Impulse Response');
  set(th, 'FontSize', TITLE_SIZE);
  xlabel(handles.ax_imp, 'Samples (n)');
  ylabel(handles.ax_imp, 'Amplitude');
  grid(handles.ax_imp, 'on');

  % Coefficient table (bottom-right quadrant)
  uicontrol('Parent', parent, 'Style', 'text', ...
    'Units', 'normalized', 'Position', [0.55 0.41 0.42 0.03], ...
    'String', 'Coefficients', ...
    'FontWeight', 'bold', 'FontSize', TITLE_SIZE, ...
    'HorizontalAlignment', 'center');

  handles.tbl_coeffs = uitable('Parent', parent, ...
    'Units', 'normalized', 'Position', [0.55 0.05 0.42 0.36], ...
    'ColumnName', {'Index', 'b (num)', 'a (den)'}, ...
    'ColumnWidth', {40, 90, 90}, ...
    'RowName', {}, ...
    'Data', {});
end
