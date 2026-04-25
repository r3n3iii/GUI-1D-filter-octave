%% DESCRIPTION
%  Unit tests for validate_params, validate_fir, and validate_iir.
%% INPUTS
%  none
%% OUTPUTS
%  none — throws on failure

function test_validate_params()
  % --- existing ---
  t_fir_valid_lowpass();
  t_fir_order_too_low();
  t_fir_wn_out_of_range_high();
  t_fir_wn_out_of_range_low();
  t_fir_bandpass_odd_order();
  t_fir_bandpass_scalar_wn();
  t_fir_bandpass_wn_reversed();
  t_fir_bandpass_valid();
  % --- new: band type coverage ---
  t_fir_highpass_valid();
  t_fir_bandstop_valid();
  t_fir_bandstop_odd_order();
  % --- new: Wn shape rules ---
  t_fir_vector_wn_with_lowpass();
  t_fir_vector_wn_with_highpass();
  % --- new: boundary values ---
  t_fir_order_zero();
  t_fir_wn_near_boundary_valid();
end

function t_fir_valid_lowpass()
  h = base_handles();
  r = validate_params(h);
  if ~r.ok
    error('t_fir_valid_lowpass: expected ok, got: %s', r.message);
  end
end

function t_fir_order_too_low()
  h = base_handles();
  h.filter_order = 1;
  r = validate_params(h);
  if r.ok
    error('t_fir_order_too_low: should have failed for order 1');
  end
end

function t_fir_wn_out_of_range_high()
  h = base_handles();
  h.Wn = 1.0;
  r = validate_params(h);
  if r.ok
    error('t_fir_wn_out_of_range_high: should have failed for Wn=1.0');
  end
end

function t_fir_wn_out_of_range_low()
  h = base_handles();
  h.Wn = 0.0;
  r = validate_params(h);
  if r.ok
    error('t_fir_wn_out_of_range_low: should have failed for Wn=0.0');
  end
end

function t_fir_bandpass_odd_order()
  h = base_handles();
  h.band_type    = 'bandpass';
  h.Wn           = [0.2 0.5];
  h.filter_order = 41;
  r = validate_params(h);
  if r.ok
    error('t_fir_bandpass_odd_order: should have failed for odd order bandpass');
  end
end

function t_fir_bandpass_scalar_wn()
  h = base_handles();
  h.band_type = 'bandpass';
  h.Wn        = 0.3;
  r = validate_params(h);
  if r.ok
    error('t_fir_bandpass_scalar_wn: should have failed for scalar Wn with bandpass');
  end
end

function t_fir_bandpass_wn_reversed()
  h = base_handles();
  h.band_type = 'bandpass';
  h.Wn        = [0.5 0.2];
  r = validate_params(h);
  if r.ok
    error('t_fir_bandpass_wn_reversed: should have failed for reversed Wn');
  end
end

function t_fir_bandpass_valid()
  h = base_handles();
  h.band_type    = 'bandpass';
  h.Wn           = [0.2 0.5];
  h.filter_order = 40;
  r = validate_params(h);
  if ~r.ok
    error('t_fir_bandpass_valid: expected ok, got: %s', r.message);
  end
end

% --- new: band type coverage ---

function t_fir_highpass_valid()
  h = base_handles();
  h.band_type = 'high';
  r = validate_params(h);
  if ~r.ok
    error('t_fir_highpass_valid: expected ok, got: %s', r.message);
  end
end

function t_fir_bandstop_valid()
  h = base_handles();
  h.band_type    = 'stop';
  h.Wn           = [0.2 0.5];
  h.filter_order = 40;
  r = validate_params(h);
  if ~r.ok
    error('t_fir_bandstop_valid: expected ok, got: %s', r.message);
  end
end

function t_fir_bandstop_odd_order()
  h = base_handles();
  h.band_type    = 'stop';
  h.Wn           = [0.2 0.5];
  h.filter_order = 41;
  r = validate_params(h);
  if r.ok
    error('t_fir_bandstop_odd_order: should have failed for odd order bandstop');
  end
end

% --- new: Wn shape rules ---

function t_fir_vector_wn_with_lowpass()
  h = base_handles();
  h.band_type = 'low';
  h.Wn        = [0.2 0.4];
  r = validate_params(h);
  if r.ok
    error('t_fir_vector_wn_with_lowpass: should fail — lowpass requires scalar Wn');
  end
end

function t_fir_vector_wn_with_highpass()
  h = base_handles();
  h.band_type = 'high';
  h.Wn        = [0.2 0.4];
  r = validate_params(h);
  if r.ok
    error('t_fir_vector_wn_with_highpass: should fail — highpass requires scalar Wn');
  end
end

% --- new: boundary values ---

function t_fir_order_zero()
  h = base_handles();
  h.filter_order = 0;
  r = validate_params(h);
  if r.ok
    error('t_fir_order_zero: should have failed for order=0');
  end
end

function t_fir_wn_near_boundary_valid()
  h = base_handles();
  h.Wn = 0.01;
  r = validate_params(h);
  if ~r.ok
    error('t_fir_wn_near_boundary_valid: Wn=0.01 is valid (exclusive lower bound is 0), got: %s', r.message);
  end
  h.Wn = 0.99;
  r = validate_params(h);
  if ~r.ok
    error('t_fir_wn_near_boundary_valid: Wn=0.99 is valid (exclusive upper bound is 1), got: %s', r.message);
  end
end

function h = base_handles()
  h.filter_type  = 'FIR';
  h.design_method = 'window';
  h.window_type  = 'hamming';
  h.filter_order = 40;
  h.band_type    = 'low';
  h.Wn           = 0.3;
  h.Rp           = 1;
  h.Rs           = 40;
  h.Fs           = 2;
end
