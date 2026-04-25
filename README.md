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

Copyright (c) 2026 Rene Ayoroa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
