%% DESCRIPTION
%  Dispatches parameter validation to the method-specific validator.
%% INPUTS
%  handles  struct — application state
%% OUTPUTS
%  result  struct — .ok (bool), .message (string)

function result = validate_params(handles)
  result.ok      = false;
  result.message = '';

  params.order  = handles.filter_order;
  params.Wn     = handles.Wn;
  params.band   = handles.band_type;
  params.Rp     = handles.Rp;
  params.Rs     = handles.Rs;
  params.method = handles.design_method;

  if strcmp(handles.filter_type, 'FIR')
    params.window = handles.window_type;
    if isfield(handles, 'kaiser_beta')
      params.kaiser_beta = handles.kaiser_beta;
    else
      params.kaiser_beta = 0;
    end

    if any(strcmp(handles.design_method, {'ls', 'pm'}))
      result = validate_ls_pm(handles);
    else
      result = validate_fir(params);
    end
  else
    result = validate_iir(params);
  end
end

% Validates LS/PM band-edge ordering and basic order requirement.
function result = validate_ls_pm(handles)
  result.ok      = false;
  result.message = '';

  if handles.filter_order < 2
    result.message = 'Order must be >= 2.';
    return;
  end

  is_2band = any(strcmp(handles.band_type, {'bandpass', 'stop'}));

  if is_2band && mod(handles.filter_order, 2) ~= 0
    result.message = 'Order must be even for bandpass/bandstop filters.';
    return;
  end

  f1 = handles.fpass;
  f2 = handles.fstop;

  if f1 <= 0 || f1 >= 1
    result.message = 'First frequency edge must be in the open interval (0, 1).';
    return;
  end
  if f2 <= 0 || f2 >= 1
    result.message = 'Second frequency edge must be in the open interval (0, 1).';
    return;
  end
  if f1 >= f2
    result.message = 'Frequency edges must be strictly increasing (f1 < f2).';
    return;
  end

  if is_2band
    f3 = handles.fpass2;
    f4 = handles.fstop2;
    if f3 <= 0 || f3 >= 1
      result.message = 'Third frequency edge must be in the open interval (0, 1).';
      return;
    end
    if f4 <= 0 || f4 >= 1
      result.message = 'Fourth frequency edge must be in the open interval (0, 1).';
      return;
    end
    if f2 >= f3
      result.message = 'Frequency edges must be strictly increasing (f2 < f3).';
      return;
    end
    if f3 >= f4
      result.message = 'Frequency edges must be strictly increasing (f3 < f4).';
      return;
    end
  end

  if handles.Wpass <= 0 || handles.Wstop <= 0
    result.message = 'Wpass and Wstop must be positive.';
    return;
  end

  result.ok = true;
end
