%% DESCRIPTION
%  Designs an IIR Butterworth filter (wraps butter).
%% INPUTS
%  params  struct — .order, .Wn, .band
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  vector — denominator coefficients

function [b, a] = design_iir_butter(params)
  [b, a] = butter(params.order, params.Wn, params.band);
end
