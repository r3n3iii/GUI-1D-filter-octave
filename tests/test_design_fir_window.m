%% DESCRIPTION
%  Unit tests for design_fir_window.
%% INPUTS
%  none
%% OUTPUTS
%  none — throws on failure

function test_design_fir_window()
  t_length();
  t_symmetry();
  t_lowpass_dc_gain();
  t_highpass_dc_gain();
  t_bandpass_length();
  t_kaiser_window();
  t_unknown_window_errors();
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
  p = base_params();
  p.band = 'high';
  [b, ~] = design_fir_window(p);
  assert_near(sum(b), 0.0, 1e-6, 'highpass DC gain must be ~0');
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

function p = base_params()
  p.order       = 40;
  p.Wn          = 0.3;
  p.band        = 'low';
  p.window      = 'hamming';
  p.kaiser_beta = 0;
end
