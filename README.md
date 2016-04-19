# OpenCV

The package is re-organized into https://github.com/JuliaCV to simplify development and minimize dependencies. See [README.org.md](README.org.md) for previous README.

## Installation

```jl
Pkg.clone("https://github.com/JuliaOpenCV/CVCore")
Pkg.clone("https://github.com/JuliaOpenCV/CVHighGUI")
Pkg.clone("https://github.com/JuliaOpenCV/CVImgProc")
Pkg.clone("https://github.com/JuliaOpenCV/CVImgCodecs")
Pkg.clone("https://github.com/JuliaOpenCV/CVVideoIO")
Pkg.clone("https://github.com/JuliaOpenCV/LibOpenCV")
Pkg.clone("https://github.com/JuliaOpenCV/OpenCV")
```

```jl
Pkg.build("LibOpenCV")
```
