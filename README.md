# OpenCV

A Julia wrapper for [OpenCV](https://github.com/Itseez/opencv) based on Cxx.jl

Note that OpenCV.jl was started as an experimental project and not full-featured for now.

## Features

- **core**
 - Mat, UMat, MatExpr and matrix operations.
 - *Mat and Julia array conversions*
- **highgui**
- **imgcodecs**
- **imgproc**
- **videoio**

## Dependencies

- [Cxx.jl](https://github.com/Keno/Cxx.jl)
- opencv v3.0.0 (automatically detected or installed).

## Installation

You fist need to install [Cxx.jl](https://github.com/Keno/Cxx.jl). And then, you can install OpenCV.jl by:

```jl
Pkg.clone("https://github.com/r9y9/OpenCV.jl.git")
Pkg.build("OpenCV")
```

This should install OpenCV.jl and resolve its binary dependency property. If you do not have opencv installed, `Pkg.build("OpenCV")` will try to install opencv v3.0.0 in the package directory.

Before using OpenCV.jl, you will need to add the opencv libraries path to `LD_LIBRARY_PATH` or `DYLD_LIBRARY_PATH`.

### osx

```
export DYLD_LIBRARY_PATH=$HOME/.julia/v0.5/OpenCV/deps/usr/lib:$DYLD_LIBRARY_PATH
```

## Examples

See [examples](./examples).
