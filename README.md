# OpenCV

The package is re-organized into https://github.com/JuliaOpenCV to simplify development and minimize dependencies. Note that OpenCV packages are **much work in progress** and there's almost no docs. Please file an issue if you have any trouble or request for docs, etc. Currently only tested on OSX.

## Requirements

- Julia (master) with [Keno/Cxx.jl](https://github.com/Keno/Cxx.jl)
- OpenCV 3.1.0 (built as shared libraries)

## Installation

```jl
Pkg.clone("https://github.com/JuliaOpenCV/CVCore.jl")
Pkg.clone("https://github.com/JuliaOpenCV/CVHighGUI.jl")
Pkg.clone("https://github.com/JuliaOpenCV/CVImgProc.jl")
Pkg.clone("https://github.com/JuliaOpenCV/CVImgCodecs.jl")
Pkg.clone("https://github.com/JuliaOpenCV/CVVideoIO.jl")
Pkg.clone("https://github.com/JuliaOpenCV/LibOpenCV.jl")
Pkg.clone("https://github.com/JuliaOpenCV/OpenCV.jl")
```

```jl
Pkg.build("LibOpenCV")
```
