%% DESCRIPTION
%  Unit tests for design_iir_ellip.
%% INPUTS
%  none
%% OUTPUTS
%  none — throws on failure

function test_design_iir_ellip()
  t_coeff_length();
  t_stability();
  t_lowpass_passband_gain();
  t_lowpass_stopband_gain();
  t_cutoff_gain();
  t_highpass_gains();
  t_bandpass_gains();
end

function t_coeff_length()
  p = base_params();
  [b, a] = design_iir_ellip(p);
  if numel(b) ~= p.order + 1
    error('t_coeff_length: b should have order+1 elements, got %d', numel(b));
  end
  if numel(a) ~= p.order + 1
    error('t_coeff_length: a should have order+1 elements, got %d', numel(a));
  end
end

function t_stability()
  p = base_params();
  [~, a] = design_iir_ellip(p);
  poles = roots(a);
  if any(abs(poles) >= 1)
    error('t_stability: elliptic filter has poles outside the unit circle');
  end
end

function t_lowpass_passband_gain()
  p = base_params();
  [b, a] = design_iir_ellip(p);
  % Equiripple passband: gain oscillates between 10^(-Rp/20)≈0.891 and 1.0
  if eval_gain(b, a, 0.1) < 0.85
    error('t_lowpass_passband_gain: gain at f=0.1 should be > 0.85');
  end
end

function t_lowpass_stopband_gain()
  p = base_params();
  [b, a] = design_iir_ellip(p);
  % Elliptic has the sharpest transition — stopband starts very close to Wn
  if eval_gain(b, a, 0.4) > 0.05
    error('t_lowpass_stopband_gain: gain at f=0.4 should be < 0.05 (Rs=40dB)');
  end
end

function t_cutoff_gain()
  % At f=Wn the elliptic filter reaches exactly 10^(-Rp/20), same as Cheby I.
  p = base_params();
  [b, a] = design_iir_ellip(p);
  expected = 10^(-p.Rp / 20);
  assert_near(eval_gain(b, a, p.Wn), expected, 0.02, 'elliptic cutoff gain');
end

function t_highpass_gains()
  p = base_params();
  p.band = 'high';
  [b, a] = design_iir_ellip(p);
  % Wn=0.3 is the passband edge for elliptic highpass → f=0.45 is in passband
  if eval_gain(b, a, 0.45) < 0.85
    error('t_highpass_gains: passband gain at f=0.45 should be > 0.85');
  end
  if eval_gain(b, a, 0.1) > 0.05
    error('t_highpass_gains: stopband gain at f=0.1 should be < 0.05');
  end
  poles = roots(a);
  if any(abs(poles) >= 1)
    error('t_highpass_gains: highpass elliptic filter is unstable');
  end
end

function t_bandpass_gains()
  p.order = 4;
  p.Rp    = 1;
  p.Rs    = 40;
  p.Wn    = [0.2 0.5];
  p.band  = 'bandpass';
  [b, a] = design_iir_ellip(p);
  if eval_gain(b, a, 0.35) < 0.85
    error('t_bandpass_gains: mid-passband gain at f=0.35 should be > 0.85');
  end
  if eval_gain(b, a, 0.05) > 0.05
    error('t_bandpass_gains: stopband gain at f=0.05 should be < 0.05');
  end
  poles = roots(a);
  if any(abs(poles) >= 1)
    error('t_bandpass_gains: bandpass elliptic filter is unstable');
  end
end

function gain = eval_gain(b, a, f_norm)
  z = exp(1j * pi * f_norm);
  gain = abs(polyval(b, z) / polyval(a, z));
end

function p = base_params()
  p.order = 4;
  p.Rp    = 1;
  p.Rs    = 40;
  p.Wn    = 0.3;
  p.band  = 'low';
end
