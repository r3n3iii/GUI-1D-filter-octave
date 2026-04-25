%% DESCRIPTION
%  Returns the divisor and x-axis label for the current frequency unit.
%% INPUTS
%  freq_unit  string — 'Hz' | 'kHz' | 'MHz' | 'GHz' | 'Normalized'
%  Fs         scalar — sample rate in Hz (needed for Normalized scale)
%% OUTPUTS
%  scale      scalar — divide Hz values by this to get display values
%  lbl        string — x-axis label

function [scale, lbl] = freq_axis_scale(freq_unit, Fs)
  switch freq_unit
    case 'kHz';        scale = 1e3;    lbl = 'Frequency (kHz)';
    case 'MHz';        scale = 1e6;    lbl = 'Frequency (MHz)';
    case 'GHz';        scale = 1e9;    lbl = 'Frequency (GHz)';
    case 'Normalized'; scale = Fs/2;   lbl = 'Normalized Frequency (0-1)';
    otherwise;         scale = 1;      lbl = 'Frequency (Hz)';
  end
end
