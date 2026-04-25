%% DESCRIPTION
%  Populates the coefficient table with b (numerator) and a (denominator) vectors.
%% INPUTS
%  handles  struct — application state (.b, .a, .tbl_coeffs)
%% OUTPUTS
%  none

function update_coeff_table(handles)
  b = handles.b(:);
  a = handles.a(:);
  N = max(numel(b), numel(a));
  b(end+1:N) = 0;
  a(end+1:N) = 0;
  idx  = num2cell((1:N)');
  data = [idx, num2cell(b), num2cell(a)];
  set(handles.tbl_coeffs, 'Data', data);
end
