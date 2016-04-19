# OpenCV

A Julia wrapper for [OpenCV](https://github.com/Itseez/opencv) based on Cxx.jl

<div align="center"><img src="examples/data/video_thresholding.gif"></div>

Note that OpenCV.jl was started as an experimental project and not full-featured.

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

## A minimum example

```jl
using OpenCV

img = cv2.imread("test.jpg")
img = cv2.UMat(img)
gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
bin = cv2.threshold(gray, 170, 255, cv2.THRESH_OTSU)

cv2.imwrite("test_bin.jpg", bin)
```

See [examples](./examples) directory for more examples.

## Note

You might know there already exists a Julia wrapper for opencv: [OpenCV.jl](https://github.com/maxruby/OpenCV.jl). The reason why I created a new one is that I wanted to start with a small code base and re-design the interface.
