%% DESCRIPTION
%  Designs an IIR Chebyshev Type II filter (wraps cheby2).
%% INPUTS
%  params  struct — .order, .Rs, .Wn, .band
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  vector — denominator coefficients

function [b, a] = design_iir_cheby2(params)
  % 'low' and 'bandpass' are defaults in Octave's cheby2 — only pass string for 'high'/'stop'.
  if any(strcmp(params.band, {'low', 'bandpass'}))
    [b, a] = cheby2(params.order, params.Rs, params.Wn);
  else
    [b, a] = cheby2(params.order, params.Rs, params.Wn, params.band);
  end
end
