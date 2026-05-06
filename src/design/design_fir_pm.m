%% DESCRIPTION
%  Designs a FIR filter using the Parks-McClellan algorithm (wraps remez).
%% INPUTS
%  params   struct  — .order, .F, .A, .W
%  density  scalar  — grid density factor (default 20); higher = more accurate
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  scalar — always 1 for FIR

function [b, a] = design_fir_pm(params, density)
  if nargin < 2 || isempty(density)
    density = 20;
  end
  b = remez(params.order, params.F, params.A, params.W, density);
  a = 1;
end
