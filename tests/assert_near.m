%% DESCRIPTION
%  Asserts that actual and expected are element-wise within tol. Throws on failure.
%% INPUTS
%  actual    numeric — computed value
%  expected  numeric — reference value
%  tol       scalar  — absolute tolerance (default 1e-6)
%  msg       string  — optional label for the error message
%% OUTPUTS
%  none — throws if max(|actual - expected|) > tol

function assert_near(actual, expected, tol, msg)
  if nargin < 3
    tol = 1e-6;
  end
  if nargin < 4
    msg = '';
  end
  diff = max(abs(actual(:) - expected(:)));
  if diff > tol
    if isempty(msg)
      error('assert_near: max difference %.3e exceeds tolerance %.3e', diff, tol);
    else
      error('assert_near: %s — max difference %.3e exceeds tolerance %.3e', msg, diff, tol);
    end
  end
end
