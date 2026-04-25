%% DESCRIPTION
%  Unit tests for design_fir_ls.
%% INPUTS
%  none
%% OUTPUTS
%  none — throws on failure

function test_design_fir_ls()
  % --- existing ---
  t_length();
  t_symmetry();
  t_lowpass_dc_gain();
  t_bandpass_length();
  % --- P1: frequency response ---
  t_passband_gain();
  t_stopband_gain();
  % --- P2: bandstop ---
  t_bandstop_length();
  % --- P4: edge cases ---
  t_unequal_weights();
  t_three_band();
end

function t_length()
  p = base_params();
  [b, a] = design_fir_ls(p);
  if numel(b) ~= p.order + 1
    error('t_length: expected %d coefficients, got %d', p.order + 1, numel(b));
  end
  if a ~= 1
    error('t_length: a must equal 1 for FIR');
  end
end

function t_symmetry()
  p = base_params();
  [b, ~] = design_fir_ls(p);
  assert_near(b, fliplr(b), 1e-10, 'firls output must be symmetric (linear phase)');
end

function t_lowpass_dc_gain()
  p = base_params();
  [b, ~] = design_fir_ls(p);
  % firls minimizes squared error, so DC gain is close but not exact;
  % use generous tolerance matching typical passband ripple.
  assert_near(sum(b), 1.0, 0.05, 'lowpass firls DC gain must be ~1');
end

function t_bandpass_length()
  p.order = 40;
  p.F     = [0 0.2 0.3 0.6 0.7 1];
  p.A     = [0 0   1   1   0   0];
  p.W     = [1 2 1];
  [b, ~] = design_fir_ls(p);
  if numel(b) ~= p.order + 1
    error('t_bandpass_length: expected %d coefficients, got %d', p.order + 1, numel(b));
  end
  assert_near(b, fliplr(b), 1e-10, 'bandpass firls must be symmetric');
end

% --- P1: frequency response ---

function t_passband_gain()
  p = base_params();
  [b, ~] = design_fir_ls(p);
  if eval_gain(b, 0.15) < 0.9
    error('t_passband_gain: gain at f=0.15 (mid-passband) should be > 0.9');
  end
end

function t_stopband_gain()
  p = base_params();
  [b, ~] = design_fir_ls(p);
  if eval_gain(b, 0.7) > 0.1
    error('t_stopband_gain: gain at f=0.7 (mid-stopband) should be < 0.1');
  end
end

% --- P2: bandstop ---

function t_bandstop_length()
  p.order = 40;
  p.F     = [0 0.1 0.3 0.6 0.7 1];
  p.A     = [1 1   0   0   1   1];
  p.W     = [1 1 1];
  [b, ~] = design_fir_ls(p);
  if numel(b) ~= p.order + 1
    error('t_bandstop_length: expected %d coefficients, got %d', p.order + 1, numel(b));
  end
  assert_near(b, fliplr(b), 1e-10, 'bandstop firls must be symmetric');
end

% --- P4: edge cases ---

function t_unequal_weights()
  p = base_params();
  p.W = [10 1];
  [b, ~] = design_fir_ls(p);
  if eval_gain(b, 0.15) < 0.95
    error('t_unequal_weights: W=[10 1] should tighten passband; gain at 0.15 should be > 0.95');
  end
end

function t_three_band()
  p.order = 40;
  p.F     = [0 0.2 0.3 0.7 0.8 1];
  p.A     = [0 0   1   1   0   0];
  p.W     = [1 2 1];
  [b, ~] = design_fir_ls(p);
  if numel(b) ~= p.order + 1
    error('t_three_band: expected %d coefficients, got %d', p.order + 1, numel(b));
  end
  assert_near(b, fliplr(b), 1e-10, 'three-band firls must be symmetric');
end

% --- helpers ---

function gain = eval_gain(b, f_norm)
  z = exp(1j * pi * f_norm);
  gain = abs(polyval(b, z));
end

function p = base_params()
  p.order = 40;
  p.F     = [0 0.3 0.4 1];
  p.A     = [1 1   0   0];
  p.W     = [1 1];
end
