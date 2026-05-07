%% DESCRIPTION
%  Computes descriptive information about the current filter.
%% INPUTS
%  b            vector — numerator coefficients
%  a            vector — denominator coefficients
%  Fs           scalar — sample rate in Hz
%  struct_idx   scalar — index into Structure dropdown (1=DF, 2=SOS, 3=SS)
%  freq_unit    string — display unit: 'Hz'|'kHz'|'MHz'|'GHz'|'Normalized'
%% OUTPUTS
%  rows  Nx2 cell — {property, value} pairs ready for uitable

function rows = compute_filter_info(b, a, Fs, struct_idx, freq_unit)
  if nargin < 5; freq_unit = 'Hz'; end

  is_fir = (numel(a) == 1 && a(1) == 1);
  order  = max(numel(b), numel(a)) - 1;

  % ---- Type string ---------------------------------------------------------
  if is_fir
    type_str = 'FIR (real)';
  else
    type_str = 'IIR (real)';
  end

  % ---- Structure string ----------------------------------------------------
  STRUCT_NAMES = {'Direct Form (b/a)', 'Second-Order Sections', 'State-Space'};
  if struct_idx >= 1 && struct_idx <= 3
    struct_str = STRUCT_NAMES{struct_idx};
  else
    struct_str = 'Direct Form (b/a)';
  end

  % ---- Stability -----------------------------------------------------------
  poles_v = roots(a);
  if all(abs(poles_v) <= 1 + 1e-10)
    stable_str = 'Yes';
  else
    stable_str = 'NO  (poles outside unit circle)';
  end

  % ---- Linear phase (FIR only) --------------------------------------------
  if is_fir
    lp_str = linear_phase_type(b);
  else
    lp_str = 'N/A  (IIR)';
  end

  % ---- Frequency response metrics -----------------------------------------
  [H, W] = freqz(b, a, 4096);
  mag    = abs(H);
  mag_db = 20 * log10(mag + eps);

  max_db = max(mag_db);

  % Passband ripple — peak-to-peak oscillation within passband
  % (droop is not ripple: monotone responses report 0 dB)
  pb_mask = mag_db >= max_db - 3;
  pb_mag  = mag_db(pb_mask);
  if numel(pb_mag) > 2
    d       = diff(pb_mag);
    loc_max = find(d(1:end-1) > 0 & d(2:end) < 0);
    loc_min = find(d(1:end-1) < 0 & d(2:end) > 0);
    if ~isempty(loc_max) && ~isempty(loc_min)
      rp_val = mean(pb_mag(loc_max + 1)) - mean(pb_mag(loc_min + 1));
      if rp_val > 1e-6
        Rp_str = sprintf('%.4g dB  (peak-to-peak)', rp_val);
      else
        Rp_str = '0 dB  (monotone passband)';
      end
    else
      Rp_str = '0 dB  (monotone passband)';
    end
  else
    Rp_str = 'N/A';
  end

  % Stopband attenuation — minimum attenuation where mag_db < -20 dB
  sb_mask = mag_db < -20;
  if any(sb_mask)
    Rs_str = sprintf('%.4g dB', -max(mag_db(sb_mask)));
  else
    Rs_str = 'N/A  (no region below -20 dB)';
  end

  % -3 dB rows (shape-aware: LPF / HPF / BPF / BSF)
  f3db_rows = build_f3db_rows(W, mag_db, max_db, Fs, freq_unit);

  % ---- Sample rate string --------------------------------------------------
  if strcmp(freq_unit, 'Normalized')
    sr_str = 'N/A  (not specified in Normalized mode)';
  else
    sr_str = sprintf('%.6g Hz', Fs);
  end

  % ---- Assemble rows -------------------------------------------------------
  rows = [ ...
    {'Filter Type',          type_str        }; ...
    {'Structure',            struct_str       }; ...
    {'Filter Order',         num2str(order)   }; ...
    {'Filter Length',        num2str(numel(b))}; ...
    {'Sample Rate',          sr_str           }; ...
    {'---',                  '---'            }; ...
    {'Stable',               stable_str       }; ...
    {'Linear Phase',         lp_str           }; ...
    {'---',                  '---'            }; ...
    f3db_rows; ...
    {'Passband Ripple (Rp)', Rp_str           }; ...
    {'Stopband Atten. (Rs)', Rs_str           }; ...
  ];
end

% Returns an Nx2 cell array of -3 dB rows, shaped for the filter type.
% Shape is inferred from the frequency response — no band_type param needed.
function rows = build_f3db_rows(W, mag_db, max_db, Fs, freq_unit)
  threshold = max_db - 3;
  above     = mag_db >= threshold;
  xings     = find(diff(above) ~= 0);   % indices just before each crossing

  if isempty(xings)
    if above(1)
      rows = {'-3 dB Cutoff', 'N/A  (passband covers full range)'};
    else
      rows = {'-3 dB Cutoff', 'N/A  (signal below -3 dB everywhere)'};
    end

  elseif numel(xings) == 1
    f = freq_str(W, xings(1), Fs, freq_unit);
    rows = {'Cutoff (-3 dB)', f};

  elseif numel(xings) == 2
    f1  = freq_str(W, xings(1), Fs, freq_unit);
    f2  = freq_str(W, xings(2), Fs, freq_unit);
    wn1 = W(xings(1)) / pi;
    wn2 = W(xings(2)) / pi;
    if ~above(1)      % stopband → passband → stopband: bandpass
      bw = bw_str(wn1, wn2, Fs, freq_unit);
      rows = {
        'Lower cutoff (-3 dB)', f1;
        'Upper cutoff (-3 dB)', f2;
        'Bandwidth',            bw;
      };
    else              % passband → stopband → passband: bandstop / notch
      rows = {
        'Lower -3 dB edge', f1;
        'Upper -3 dB edge', f2;
      };
    end

  else
    % Complex response — report first and last crossings
    f1 = freq_str(W, xings(1),   Fs, freq_unit);
    f2 = freq_str(W, xings(end), Fs, freq_unit);
    rows = {
      'First -3 dB crossing', f1;
      'Last  -3 dB crossing', f2;
    };
  end

  rows = [rows; {'  * Note', '-3 dB assumes flat passband'}];
end

% Format a crossing frequency using the active display unit.
% W is in rad/sample (from freqz without Fs); xing is the index just before
% the threshold crossing.
function s = freq_str(W, xing, Fs, freq_unit)
  w_mid = (W(xing) + W(min(xing + 1, numel(W)))) / 2;
  f_wn  = w_mid / pi;          % normalized 0-1 (Wn convention, 1 = Nyquist)
  f_hz  = f_wn * (Fs / 2);    % Hz
  switch freq_unit
    case 'Normalized'; s = sprintf('%.4g', f_wn);
    case 'kHz';        s = sprintf('%.4g kHz', f_hz / 1e3);
    case 'MHz';        s = sprintf('%.4g MHz', f_hz / 1e6);
    case 'GHz';        s = sprintf('%.4g GHz', f_hz / 1e9);
    otherwise;         s = sprintf('%.4g Hz',  f_hz);
  end
end

% Format a bandwidth value using the active display unit.
% wn1, wn2 are normalized frequencies (Wn convention, 0-1).
function s = bw_str(wn1, wn2, Fs, freq_unit)
  bw_wn = wn2 - wn1;
  bw_hz = bw_wn * (Fs / 2);
  switch freq_unit
    case 'Normalized'; s = sprintf('%.4g', bw_wn);
    case 'kHz';        s = sprintf('%.4g kHz', bw_hz / 1e3);
    case 'MHz';        s = sprintf('%.4g MHz', bw_hz / 1e6);
    case 'GHz';        s = sprintf('%.4g GHz', bw_hz / 1e9);
    otherwise;         s = sprintf('%.4g Hz',  bw_hz);
  end
end

% Returns a string describing the linear phase type of a FIR filter.
function str = linear_phase_type(b)
  M   = numel(b);
  tol = max(1e-10, 1e-6 * max(abs(b)));

  is_sym     = max(abs(b(:) - flipud(b(:)))) < tol;
  is_antisym = max(abs(b(:) + flipud(b(:)))) < tol;

  if is_sym
    if mod(M, 2) == 1
      str = 'Yes  (Type I — odd order, symmetric)';
    else
      str = 'Yes  (Type II — even order, symmetric)';
    end
  elseif is_antisym
    if mod(M, 2) == 1
      str = 'Yes  (Type III — odd order, antisymmetric)';
    else
      str = 'Yes  (Type IV — even order, antisymmetric)';
    end
  else
    str = 'No';
  end
end
