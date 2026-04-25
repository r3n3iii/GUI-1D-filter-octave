%% DESCRIPTION
%  Unit tests for design_fir_window.
%% INPUTS
%  none
%% OUTPUTS
%  none — throws on failure

function test_design_fir_window()
  % --- existing ---
  t_length();
  t_symmetry();
  t_lowpass_dc_gain();
  t_highpass_dc_gain();
  t_bandpass_length();
  t_kaiser_window();
  t_unknown_window_errors();
  % --- P1: frequency response ---
  t_lowpass_passband_gain();
  t_lowpass_stopband_gain();
  t_highpass_passband_gain();
  t_highpass_stopband_gain();
  % --- P2: bandstop ---
  t_bandstop_dc_gain();
  t_bandstop_symmetry();
  t_bandstop_stopband_gain();
  % --- P3: window type coverage ---
  t_window_hanning();
  t_window_blackman();
  t_window_rectangular();
  t_kaiser_beta_zero();
  % --- P4: edge cases ---
  t_minimum_order();
  t_wn_near_boundary();
end

function t_length()
  p = base_params();
  [b, a] = design_fir_window(p);
  if numel(b) ~= p.order + 1
    error('t_length: expected %d coefficients, got %d', p.order + 1, numel(b));
  end
  if a ~= 1
    error('t_length: a must equal 1 for FIR');
  end
end

function t_symmetry()
  p = base_params();
  [b, ~] = design_fir_window(p);
  assert_near(b, fliplr(b), 1e-10, 'lowpass hamming must be symmetric');
end

function t_lowpass_dc_gain()
  p = base_params();
  [b, ~] = design_fir_window(p);
  assert_near(sum(b), 1.0, 1e-6, 'lowpass DC gain must be ~1');
end

function t_highpass_dc_gain()
  % Hamming window gives ~41 dB minimum stopband attenuation (~0.009 linear),
  % so DC gain of a highpass will not be exactly 0 — check it is adequately suppressed.
  p = base_params();
  p.band = 'high';
  [b, ~] = design_fir_window(p);
  assert_near(sum(b), 0.0, 0.01, 'highpass DC gain must be suppressed (< -40 dB)');
end

function t_bandpass_length()
  p.order       = 40;
  p.Wn          = [0.2 0.5];
  p.band        = 'bandpass';
  p.window      = 'hamming';
  p.kaiser_beta = 0;
  [b, ~] = design_fir_window(p);
  if numel(b) ~= p.order + 1
    error('t_bandpass_length: expected %d coefficients, got %d', p.order + 1, numel(b));
  end
  assert_near(b, fliplr(b), 1e-10, 'bandpass must be symmetric');
end

function t_kaiser_window()
  p = base_params();
  p.window      = 'kaiser';
  p.kaiser_beta = 6;
  [b, ~] = design_fir_window(p);
  if numel(b) ~= p.order + 1
    error('t_kaiser_window: wrong coefficient count');
  end
  assert_near(sum(b), 1.0, 1e-6, 'kaiser lowpass DC gain must be ~1');
end

function t_unknown_window_errors()
  p = base_params();
  p.window = 'unknown_window_xyz';
  try
    design_fir_window(p);
    error('t_unknown_window_errors: should have thrown for unknown window');
  catch e
    if isempty(strfind(e.message, 'unknown window type'))
      error('t_unknown_window_errors: wrong error message: %s', e.message);
    end
  end
end

% --- P1: frequency response ---

function t_lowpass_passband_gain()
  p = base_params();
  [b, ~] = design_fir_window(p);
  if eval_gain(b, 0.1) < 0.9
    error('t_lowpass_passband_gain: gain at f=0.1 should be > 0.9');
  end
end

function t_lowpass_stopband_gain()
  p = base_params();
  [b, ~] = design_fir_window(p);
  if eval_gain(b, 0.45) > 0.1
    error('t_lowpass_stopband_gain: gain at f=0.45 should be < 0.1');
  end
end

function t_highpass_passband_gain()
  p = base_params();
  p.band = 'high';
  [b, ~] = design_fir_window(p);
  if eval_gain(b, 0.45) < 0.9
    error('t_highpass_passband_gain: gain at f=0.45 should be > 0.9');
  end
end

function t_highpass_stopband_gain()
  p = base_params();
  p.band = 'high';
  [b, ~] = design_fir_window(p);
  if eval_gain(b, 0.1) > 0.1
    error('t_highpass_stopband_gain: gain at f=0.1 should be < 0.1');
  end
end

% --- P2: bandstop ---

function t_bandstop_dc_gain()
  p = bandstop_params();
  [b, ~] = design_fir_window(p);
  assert_near(sum(b), 1.0, 1e-6, 'bandstop DC gain must be ~1');
end

function t_bandstop_symmetry()
  p = bandstop_params();
  [b, ~] = design_fir_window(p);
  assert_near(b, fliplr(b), 1e-10, 'bandstop must be symmetric');
end

function t_bandstop_stopband_gain()
  p = bandstop_params();
  [b, ~] = design_fir_window(p);
  if eval_gain(b, 0.35) > 0.1
    error('t_bandstop_stopband_gain: gain at f=0.35 (mid-stop) should be < 0.1');
  end
end

% --- P3: window type coverage ---

function t_window_hanning()
  p = base_params();
  p.window = 'hann';
  [b, ~] = design_fir_window(p);
  assert_near(sum(b), 1.0, 1e-6, 'hanning lowpass DC gain must be ~1');
  assert_near(b, fliplr(b), 1e-10, 'hanning output must be symmetric');
end

function t_window_blackman()
  p = base_params();
  p.window = 'blackman';
  [b, ~] = design_fir_window(p);
  assert_near(sum(b), 1.0, 1e-6, 'blackman lowpass DC gain must be ~1');
  assert_near(b, fliplr(b), 1e-10, 'blackman output must be symmetric');
end

function t_window_rectangular()
  p = base_params();
  p.window = 'rectangular';
  [b, ~] = design_fir_window(p);
  assert_near(sum(b), 1.0, 1e-6, 'rectangular lowpass DC gain must be ~1');
  assert_near(b, fliplr(b), 1e-10, 'rectangular output must be symmetric');
end

function t_kaiser_beta_zero()
  p = base_params();
  p.window      = 'kaiser';
  p.kaiser_beta = 0;
  [b_kaiser, ~] = design_fir_window(p);
  p.window = 'rectangular';
  [b_rect, ~]   = design_fir_window(p);
  assert_near(b_kaiser, b_rect, 1e-6, 'kaiser(beta=0) must equal rectangular window');
end

% --- P4: edge cases ---

function t_minimum_order()
  p = base_params();
  p.order = 2;
  [b, ~] = design_fir_window(p);
  if numel(b) ~= 3
    error('t_minimum_order: expected 3 coefficients for order 2, got %d', numel(b));
  end
end

function t_wn_near_boundary()
  p = base_params();
  p.Wn = 0.01;
  [b, ~] = design_fir_window(p);
  if numel(b) ~= p.order + 1
    error('t_wn_near_boundary: Wn=0.01 should produce order+1 coefficients');
  end
  p.Wn = 0.99;
  [b, ~] = design_fir_window(p);
  if numel(b) ~= p.order + 1
    error('t_wn_near_boundary: Wn=0.99 should produce order+1 coefficients');
  end
end

% --- helpers ---

function gain = eval_gain(b, f_norm)
  % Evaluate |H(e^jw)| at normalized frequency f_norm in [0,1] (1 = Nyquist).
  % polyval(b, z) = z^n * H(z), and |z|=1, so magnitude is preserved.
  z = exp(1j * pi * f_norm);
  gain = abs(polyval(b, z));
end

function p = bandstop_params()
  p.order       = 40;
  p.Wn          = [0.2 0.5];
  p.band        = 'stop';
  p.window      = 'hamming';
  p.kaiser_beta = 0;
end

function p = base_params()
  p.order       = 40;
  p.Wn          = 0.3;
  p.band        = 'low';
  p.window      = 'hamming';
  p.kaiser_beta = 0;
end
