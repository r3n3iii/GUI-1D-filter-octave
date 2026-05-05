%% DESCRIPTION
%  Populates the coefficient table using the selected filter structure.
%  Supports Direct Form (b/a), Second-Order Sections, and State-Space.
%% INPUTS
%  handles  struct — application state (.b, .a, .tbl_coeffs, .dd_structure)
%% OUTPUTS
%  none

function update_coeff_table(handles)
  STRUCT_KEYS = {'df', 'sos', 'ss'};
  struct_key  = STRUCT_KEYS{get(handles.dd_structure, 'Value')};

  switch struct_key
    case 'df';  render_df(handles);
    case 'sos'; render_sos(handles);
    case 'ss';  render_ss(handles);
  end
end

% ---- Direct Form (b/a vectors) --------------------------------------------
function render_df(handles)
  b = handles.b(:);
  a = handles.a(:);
  N    = max(numel(b), numel(a));
  b    = [b; zeros(N - numel(b), 1)];
  a    = [a; zeros(N - numel(a), 1)];
  idx  = num2cell((1:N)');
  data = [idx, num2cell(b), num2cell(a)];
  set(handles.tbl_coeffs, ...
    'ColumnName',  {'Index', 'b (num)', 'a (den)'}, ...
    'ColumnWidth', {50, 120, 120}, ...
    'Data', data);
end

% ---- Second-Order Sections ------------------------------------------------
function render_sos(handles)
  try
    sos = tf2sos(handles.b, handles.a);
  catch e
    set(handles.tbl_coeffs, ...
      'ColumnName', {'Error'}, 'ColumnWidth', {300}, ...
      'Data', {{['SOS failed: ' e.message]}});
    return;
  end
  N    = size(sos, 1);
  idx  = num2cell((1:N)');
  data = [idx, num2cell(sos)];
  set(handles.tbl_coeffs, ...
    'ColumnName',  {'Section', 'b0', 'b1', 'b2', 'a0', 'a1', 'a2'}, ...
    'ColumnWidth', {55, 80, 80, 80, 80, 80, 80}, ...
    'Data', data);
end

% ---- State-Space (A, B, C, D) ---------------------------------------------
function render_ss(handles)
  try
    [A, B, C, D] = tf2ss(handles.b, handles.a);
  catch e
    set(handles.tbl_coeffs, ...
      'ColumnName', {'Error'}, 'ColumnWidth', {300}, ...
      'Data', {{['SS failed: ' e.message]}});
    return;
  end

  n = size(A, 1);

  % Column headers: blank label col, then x1..xn, then input/output col
  col_names = [{'Matrix'}, arrayfun(@(i) sprintf('x%d', i), 1:n, 'UniformOutput', false), {'| u/y'}];
  col_w     = num2cell([60, repmat(75, 1, n), 60]);

  data = {};

  % A rows + B column
  for i = 1:n
    if i == 1; lbl = 'A'; else; lbl = '  '; end
    data(end+1, :) = [{lbl}, num2cell(A(i, :)), {B(i)}];
  end

  % C row
  data(end+1, :) = [{'C'}, num2cell(C), {''}];

  % D row
  data(end+1, :) = [{'D'}, repmat({''}, 1, n), {D}];

  set(handles.tbl_coeffs, ...
    'ColumnName',  col_names, ...
    'ColumnWidth', col_w, ...
    'Data', data);
end
