%% DESCRIPTION
%  Populates the coefficient table with b (numerator) and a (denominator) vectors.
%% INPUTS
%  handles  struct — application state (.b, .a, .tbl_coeffs)
%% OUTPUTS
%  none

function update_coeff_table(handles)
  b = handles.b(:);
  a = handles.a(:);
  N    = max(numel(b), numel(a));
  b    = [b; zeros(N - numel(b), 1)];
  a    = [a; zeros(N - numel(a), 1)];
  idx  = num2cell((1:N)');
  data = [idx, num2cell(b), num2cell(a)];
  set(handles.tbl_coeffs, 'Data', data);
end
