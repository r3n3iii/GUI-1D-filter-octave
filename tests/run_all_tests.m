%% DESCRIPTION
%  Runs all unit tests and prints a pass/fail summary.
%% INPUTS
%  none
%% OUTPUTS
%  none — prints results to stdout

addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src', 'design'));
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src', 'validation'));
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src', 'plots'));

tests = {};

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
