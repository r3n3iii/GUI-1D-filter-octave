%% DESCRIPTION
%  Designs a FIR filter using least-squares method (wraps firls).
%% INPUTS
%  params  struct — .order, .F, .A, .W
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  scalar — always 1 for FIR

function [b, a] = design_fir_ls(params)
  b = firls(params.order, params.F, params.A, params.W);
  a = 1;
end
