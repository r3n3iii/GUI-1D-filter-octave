%% DESCRIPTION
%  Designs an IIR Elliptic filter (wraps ellip).
%% INPUTS
%  params  struct — .order, .Rp, .Rs, .Wn, .band
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  vector — denominator coefficients

function [b, a] = design_iir_ellip(params)
  % 'low' and 'bandpass' are defaults in Octave's ellip — only pass string for 'high'/'stop'.
  if any(strcmp(params.band, {'low', 'bandpass'}))
    [b, a] = ellip(params.order, params.Rp, params.Rs, params.Wn);
  else
    [b, a] = ellip(params.order, params.Rp, params.Rs, params.Wn, params.band);
  end
end
