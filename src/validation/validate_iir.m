%% DESCRIPTION
%  Validates IIR-specific parameters (ripple > 0, Wn range, Rs > Rp).
%% INPUTS
%  params  struct — filter parameters
%% OUTPUTS
%  result  struct — .ok (bool), .message (string)

function result = validate_iir(params)
  result.ok      = false;
  result.message = '';

  if params.order < 1
    result.message = 'Order must be >= 1 for IIR filters.';
    return;
  end

  is_band = any(strcmp(params.band, {'bandpass', 'stop'}));

  if is_band
    if numel(params.Wn) ~= 2
      result.message = 'Wn must be a 2-element vector for bandpass/bandstop.';
      return;
    end
    if params.Wn(1) >= params.Wn(2)
      result.message = 'Wn(1) must be less than Wn(2).';
      return;
    end
  else
    if numel(params.Wn) ~= 1
      result.message = 'Wn must be a scalar for lowpass/highpass.';
      return;
    end
  end

  if any(params.Wn <= 0) || any(params.Wn >= 1)
    result.message = 'Wn must be in the open interval (0, 1).';
    return;
  end

  needs_Rp = any(strcmp(params.method, {'cheby1', 'ellip'}));
  needs_Rs = any(strcmp(params.method, {'cheby2', 'ellip'}));

  if needs_Rp && params.Rp <= 0
    result.message = 'Passband ripple Rp must be > 0.';
    return;
  end

  if needs_Rs && params.Rs <= 0
    result.message = 'Stopband attenuation Rs must be > 0.';
    return;
  end

  if strcmp(params.method, 'ellip') && params.Rs <= params.Rp
    result.message = 'Rs must be greater than Rp for elliptic filters.';
    return;
  end

  result.ok = true;
end
