# Octave Filter Designer

An interactive GUI for designing and visualizing digital filters in GNU Octave — inspired by MATLAB's `filterDesigner` app. Built as an educational tool for DSP courses.

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

## Features

**FIR Filter Design**
- Window method (Hamming, Hann, Blackman, Kaiser, Rectangular)
- Least-squares (firls)
- Parks-McClellan equiripple (remez)

**IIR Filter Design**
- Butterworth
- Chebyshev Type I
- Chebyshev Type II
- Elliptic

**Band Types:** Lowpass, Highpass, Bandpass, Bandstop

**Visualization Panels**
- Magnitude frequency response (dB)
- Pole-zero diagram with unit circle
- Impulse response
- Coefficient table (b numerator, a denominator)

**Additional**
- Stability warning for filters with poles outside the unit circle
- Export coefficients to Octave workspace or file (`.mat`, `.txt`)
- Normalized frequency mode (default) or Hz mode

## Running Tests

```bash
octave --no-gui tests/run_all_tests.m
```

## License

This project is licensed under the MIT License.
