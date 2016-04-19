# OpenCV

The package is re-organized into https://github.com/JuliaCV to simplify development and minimize dependencies. See [README.org.md](README.org.md) for previous README.

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
