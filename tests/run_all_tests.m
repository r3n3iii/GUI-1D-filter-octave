%% DESCRIPTION
%  Runs all unit tests and prints a pass/fail summary.
%% INPUTS
%  none
%% OUTPUTS
%  none — prints results to stdout

pkg load signal;

root = fileparts(mfilename('fullpath'));
addpath(fullfile(root, '..', 'src', 'design'));
addpath(fullfile(root, '..', 'src', 'validation'));
addpath(fullfile(root, '..', 'src', 'plots'));
addpath(root);

tests = {
  'test_design_fir_window',
  'test_design_fir_ls',
  'test_design_fir_pm',
  'test_design_iir_butter',
  'test_design_iir_cheby1',
  'test_design_iir_cheby2',
  'test_design_iir_ellip',
  'test_validate_params',
  'test_plot_outputs',
};

passed = 0;
failed = 0;

for i = 1:numel(tests)
  try
    feval(tests{i});
    fprintf('[PASS] %s\n', tests{i});
    passed = passed + 1;
  catch e
    fprintf('[FAIL] %s — %s\n', tests{i}, e.message);
    failed = failed + 1;
  end
end

fprintf('\n%d passed, %d failed\n', passed, failed);
