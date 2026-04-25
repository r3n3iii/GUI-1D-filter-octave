%% DESCRIPTION
%  Validates FIR-specific parameters (order parity, Wn range, band rules).
%% INPUTS
%  params  struct — filter parameters
%% OUTPUTS
%  result  struct — .ok (bool), .message (string)

function result = validate_fir(params)
  result.ok      = false;
  result.message = '';

  if params.order < 2
    result.message = 'Order must be >= 2.';
    return;
  end

  is_band = any(strcmp(params.band, {'bandpass', 'stop'}));

  if is_band
    if mod(params.order, 2) ~= 0
      result.message = 'Order must be even for bandpass/bandstop filters.';
      return;
    end
    if numel(params.Wn) ~= 2
      result.message = 'Wn must be a 2-element vector for bandpass/bandstop filters.';
      return;
    end
    if params.Wn(1) >= params.Wn(2)
      result.message = 'Wn(1) must be less than Wn(2).';
      return;
    end
  else
    if numel(params.Wn) ~= 1
      result.message = 'Wn must be a scalar for lowpass/highpass filters.';
      return;
    end
  end

  if any(params.Wn <= 0) || any(params.Wn >= 1)
    result.message = 'Wn must be in the open interval (0, 1).';
    return;
  end

  result.ok = true;
end
