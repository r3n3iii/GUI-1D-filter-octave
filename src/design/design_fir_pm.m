%% DESCRIPTION
%  Designs a FIR filter using Parks-McClellan algorithm (wraps remez).
%% INPUTS
%  params  struct — .order, .F, .A, .W
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  scalar — always 1 for FIR

function [b, a] = design_fir_pm(params)
  b = remez(params.order, params.F, params.A, params.W);
  a = 1;
end
