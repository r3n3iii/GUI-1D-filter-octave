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
| Order | Filter order (integer ≥ 1) |
| Cutoff (Hz) | Cutoff frequency in Hz. For Bandpass/Bandstop enter two values: `f1 f2` |
| Fs (Hz) | Sample rate in Hz (default 8000) |
| Window | Window function — visible for FIR Window method only |
| Kaiser β | Kaiser window shape — visible when Kaiser is selected |
| Rp (dB) | Passband ripple — visible for Chebyshev I and Elliptic |
| Rs (dB) | Stopband attenuation — visible for Chebyshev II and Elliptic |
| Design Filter | Runs validation and updates all plots |
| Reset | Restores all controls to defaults |
| Export | Exports b/a to workspace, .mat, or .txt |

**Right — Plot Panel**

| Panel | Content |
|-------|---------|
| Magnitude Response | Frequency response in dB vs Hz |
| Pole-Zero Plot | Roots of b (○) and a (×) on the z-plane |
| Impulse Response | Output to a unit impulse |
| Coefficients | Scrollable table of b and a vectors |

A red stability warning appears in the control panel if any pole lies outside the unit circle.

## Supported Design Methods

**FIR**
| Method | Octave function | Notes |
|--------|----------------|-------|
| Window | `fir1` | Hamming, Hann, Blackman, Kaiser, Rectangular |
| Least-Squares | `firls` | Arbitrary piecewise-linear frequency response |
| Parks-McClellan | `remez` | Equiripple minimax design |

**IIR**
| Method | Octave function | Notes |
|--------|----------------|-------|
| Butterworth | `butter` | Maximally flat passband |
| Chebyshev I | `cheby1` | Equiripple passband, monotone stopband |
| Chebyshev II | `cheby2` | Monotone passband, equiripple stopband |
| Elliptic | `ellip` | Equiripple in both bands, sharpest rolloff |

## Running Tests

```bash
octave --no-gui tests/run_all_tests.m
```

Tests cover all 7 design methods, parameter validation, and plot output smoke tests. The suite exits with code 1 if any test fails (used by CI).

## Project Structure

```
filterdesigner.m       Entry point
src/
  design/              One file per design method
  validation/          validate_params, validate_fir, validate_iir
  plots/               plot_magnitude, plot_polezero, plot_impulse,
                       update_coeff_table, refresh_all_plots
  ui/                  build_main_window, build_control_panel,
                       build_plot_panel, build_menu,
                       apply_param_visibility
  callbacks/           cb_design_clicked, cb_filter_type,
                       cb_method_changed, cb_reset, cb_export_coeffs,
                       cb_order_changed, cb_freq_changed
tests/
  run_all_tests.m      Test runner
  assert_near.m        Numeric tolerance helper
  test_*.m             Per-module test suites
```

## License

This project is licensed under the MIT License.
