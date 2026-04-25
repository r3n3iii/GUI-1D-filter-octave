%% DESCRIPTION
%  Designs a FIR filter using the window method (wraps fir1).
%% INPUTS
%  params  struct — .order, .Wn, .band, .window, .kaiser_beta
%% OUTPUTS
%  b  vector — numerator coefficients
%  a  scalar — always 1 for FIR

function [b, a] = design_fir_window(params)
  win = make_window(params.window, params.order + 1, params.kaiser_beta);
  b = fir1(params.order, params.Wn, params.band, win);
  a = 1;
end

function w = make_window(name, n, kaiser_beta)
  switch lower(name)
    case 'hamming'
      w = hamming(n);
    case {'hann', 'hanning'}
      w = hanning(n);
    case 'blackman'
      w = blackman(n);
    case 'kaiser'
      w = kaiser(n, kaiser_beta);
    case 'rectangular'
      w = rectwin(n);
    otherwise
      error('design_fir_window: unknown window type "%s"', name);
  end
end
