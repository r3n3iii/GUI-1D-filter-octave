%% DESCRIPTION
%  Computes descriptive information about the current filter.
%% INPUTS
%  b            vector — numerator coefficients
%  a            vector — denominator coefficients
%  Fs           scalar — sample rate in Hz
%  struct_idx   scalar — index into Structure dropdown (1=DF, 2=SOS, 3=SS)
%% OUTPUTS
%  rows  Nx2 cell — {property, value} pairs ready for uitable

function rows = compute_filter_info(b, a, Fs, struct_idx)
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

  % -3 dB frequency
  below_3db = find(mag_db <= max_db - 3, 1, 'first');
  if ~isempty(below_3db)
    f3db_norm = W(below_3db) / (2*pi);          % normalised (0-0.5)
    f3db_hz   = f3db_norm * Fs;
    if Fs == 2   % caller is using normalised mode
      f3db_str = sprintf('%.4g  (normalised)', f3db_norm);
    else
      f3db_str = sprintf('%.4g Hz', f3db_hz);
    end
  else
    f3db_str = 'N/A';
  end

  % Passband ripple — peak-to-peak variation where mag_db >= max_db - 3
  pb_mask = mag_db >= max_db - 3;
  if sum(pb_mask) > 1
    Rp_str = sprintf('%.4g dB  (peak-to-peak)', max(mag_db(pb_mask)) - min(mag_db(pb_mask)));
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

  % ---- Assemble rows -------------------------------------------------------
  rows = {
    'Filter Type',           type_str;
    'Structure',             struct_str;
    'Filter Order',          num2str(order);
    'Filter Length',         num2str(numel(b));
    'Sample Rate',           sprintf('%.6g Hz', Fs);
    '---',                   '---';
    'Stable',                stable_str;
    'Linear Phase',          lp_str;
    '---',                   '---';
    '-3 dB Frequency',       f3db_str;
    'Passband Ripple (Rp)',  Rp_str;
    'Stopband Atten. (Rs)',  Rs_str;
  };
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
