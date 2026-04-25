%% DESCRIPTION
%  Dispatches parameter validation to the method-specific validator.
%% INPUTS
%  handles  struct — application state
%% OUTPUTS
%  result  struct — .ok (bool), .message (string)

function result = validate_params(handles)
  params.order = handles.filter_order;
  params.Wn    = handles.Wn;
  params.band  = handles.band_type;
  params.Rp    = handles.Rp;
  params.Rs    = handles.Rs;

  if strcmp(handles.filter_type, 'FIR')
    params.window = handles.window_type;
    if isfield(handles, 'kaiser_beta')
      params.kaiser_beta = handles.kaiser_beta;
    else
      params.kaiser_beta = 0;
    end
    result = validate_fir(params);
  else
    result = validate_iir(params);
  end
end
