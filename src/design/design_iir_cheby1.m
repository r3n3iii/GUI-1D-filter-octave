%% DESCRIPTION
%  Designs an IIR Chebyshev Type I filter (wraps cheby1).
%% INPUTS
%  params  struct — .order, .Rp, .Wn, .band
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  vector — denominator coefficients

function [b, a] = design_iir_cheby1(params)
  % 'low' and 'bandpass' are defaults in Octave's cheby1 — only pass string for 'high'/'stop'.
  if any(strcmp(params.band, {'low', 'bandpass'}))
    [b, a] = cheby1(params.order, params.Rp, params.Wn);
  else
    [b, a] = cheby1(params.order, params.Rp, params.Wn, params.band);
  end
end
