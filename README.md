# Octave Filter Designer

An interactive GUI for designing and visualizing digital filters in GNU Octave — inspired by MATLAB's `filterDesigner` app. Built as an educational tool for DSP courses.

![CI](https://github.com/r3n3iii/GUI-1D-filter-octave/actions/workflows/test.yml/badge.svg)

## Requirements

- **GNU Octave** ≥ 7.0
- **signal** package (usually bundled; install with `pkg install -forge signal` if missing)

## Launch

```bash
octave filterdesigner.m
```

Or from within an Octave session:

```octave
pkg load signal
filterdesigner
```

## Interface

The window is split into two panels:

**Left — Control Panel**

| Control | Description |
|---------|-------------|
| FIR / IIR | Selects the filter family |
| Method | Design algorithm (changes with filter type) |
| Band | Lowpass / Highpass / Bandpass / Bandstop |
| Freq Unit | Display unit for all frequency fields and plot axes: Hz / kHz / MHz / GHz / Normalized. Switching unit converts displayed values live without redesigning the filter. In Normalized mode the Fs field is hidden and all frequencies are entered as fractions of Nyquist. |
| Fs | Sample rate in the selected unit (hidden in Normalized mode) |
| **Frequency Parameters** | |
| Cutoff | Cutoff frequency (Window/IIR methods). For Bandpass/Bandstop enter two values: `f1 f2`. |
| Fpass / Fstop | Passband and stopband edge frequencies (LS and Parks-McClellan). For Bandpass/Bandstop a second pair (Fpass2 / Fstop2) also appears. |
| Order | Filter order (integer ≥ 1) |
| **Magnitude Parameters** | |
| Wpass / Wstop | Per-band weights for LS and Parks-McClellan (relative error emphasis) |
| Density | Grid density factor for Parks-McClellan (default 20; higher = more accurate, slower) |
| Rp (dB) | Passband ripple — visible for Chebyshev I and Elliptic |
| Rs (dB) | Stopband attenuation — visible for Chebyshev II and Elliptic |
| Window | Window function — visible for FIR Window method only (Hamming, Hann, Blackman, Kaiser, Rectangular) |
| Kaiser β | Kaiser window shape parameter — visible when Kaiser is selected |
| Design Filter | Validates parameters and designs the filter |
| Reset | Restores all controls and the plot to defaults |
| Import | Opens a dialog to manually enter or paste b/a coefficients |
| Export | Exports coefficients in the format selected by the Structure dropdown |

A red stability warning appears below the buttons if any pole lies outside the unit circle.

**Right — Plot Panel**

A button strip across the top selects which view is displayed in the large area below:

| Button | Content |
|--------|---------|
| Magnitude | Frequency response in dB |
| Phase | Phase response in radians. A **Wrapped / Unwrapped** toggle appears when this plot is active. |
| Ph. Delay | Phase delay in samples (−∠H(ω) / ω) |
| Grp. Delay | Group delay in samples (−d∠H(ω)/dω) |
| Pole-Zero | Roots of b (○) and roots of a (×) on the z-plane with unit circle |
| Impulse | Filter response to a unit impulse |
| Coefficients | Scrollable table of coefficients in the selected structure. A **Structure** dropdown selects: Direct Form (b/a), Second-Order Sections, or State-Space. |
| Info | Summary table: filter type, structure, order, length, sample rate, stability, linear phase type, −3 dB frequency, passband ripple, and stopband attenuation. |

The frequency axis on all frequency-domain plots reflects the active **Freq Unit** selection.

## Export Formats

The **Export** button respects the **Structure** dropdown in the Coefficients tab:

| Structure | Export options |
|-----------|---------------|
| Direct Form (b/a) | Workspace variables, `.mat`, `.txt`, `.h` (CMSIS `arm_fir_f32` — FIR only) |
| Second-Order Sections | Workspace variable, `.mat`, `.h` CMSIS DF1 (`arm_biquad_cascade_df1_f32`), `.h` CMSIS DF2T (`arm_biquad_cascade_df2T_f32`) |
| State-Space | Workspace variables (A, B, C, D), `.mat`, `.txt` |

The generated `.h` files are ready-to-include ARM CMSIS-DSP headers with coefficient arrays, state buffers, and inline `filter_init()` / `filter_process()` functions.

## Supported Design Methods

**FIR**

| Method | Octave function | Key parameters |
|--------|----------------|----------------|
| Window | `fir1` | Order, Cutoff (Wn), Window type, Kaiser β |
| Least-Squares | `firls` | Order, Fpass, Fstop, Wpass, Wstop |
| Parks-McClellan | `remez` | Order, Fpass, Fstop, Wpass, Wstop, Density |

**IIR**

| Method | Octave function | Key parameters |
|--------|----------------|----------------|
| Butterworth | `butter` | Order, Cutoff (Wn) |
| Chebyshev I | `cheby1` | Order, Wn, Rp |
| Chebyshev II | `cheby2` | Order, Wn, Rs |
| Elliptic | `ellip` | Order, Wn, Rp, Rs |

## Running Tests

```bash
octave --no-gui tests/run_all_tests.m
```

Tests cover all 7 design methods, parameter validation, and plot/refresh smoke tests. The suite exits with code 1 if any test fails (used by CI).

## Project Structure

```
filterdesigner.m       Entry point
src/
  design/              One file per design method
  validation/          validate_params, validate_fir, validate_iir
  plots/               plot_magnitude, plot_phase, plot_phase_delay,
                       plot_group_delay, plot_polezero, plot_impulse,
                       render_plot, freq_axis_scale,
                       update_coeff_table, compute_filter_info,
                       refresh_all_plots
  ui/                  build_main_window, build_control_panel,
                       build_plot_panel, build_menu,
                       apply_param_visibility
  callbacks/           cb_design_clicked, cb_filter_type,
                       cb_method_changed, cb_reset,
                       cb_import_coeffs, cb_export_coeffs,
                       cb_order_changed, cb_freq_changed,
                       cb_plot_select, cb_phase_wrap_toggle,
                       cb_freq_unit_changed, cb_structure_changed
tests/
  run_all_tests.m      Test runner
  assert_near.m        Numeric tolerance helper
  test_*.m             Per-module test suites
```

## License

This project is licensed under the MIT License.
