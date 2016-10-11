# Installation

OpenCV Julia packages have fairly complex dependencies, so please take a careful
look at the installation guide for each dependency.

## Requirements

### Platform

Currently only tested on OSX.

### opencv

You need to install [opencv](https://github.com/opencv/opencv) 3.0.0 or later
as shared libraries (`BUILD_SHARED_LIBS=ON`). For the detailed installation
instructions, see the opencv page.

### Julia

[Julia](https://github.com/JuliaLang/julia) 0.5 or later is required.
Install Julia v0.5 from binary distributions or build it from source.

### Cxx.jl

You need to install [Keno/Cxx.jl](https://github.com/Keno/Cxx.jl). Building
Cxx.jl is a bit complex, as it builds its own llvm and clang by default. Please
take a careful look at the installation guide of Cxx.jl. Ideally, the
installation can be done as follows:

```julia
Pkg.clone("https://github.com/Keno/Cxx.jl")
Pkg.build("Cxx")
```

## Install OpenCV Julia packages

### Clone and build

You are almost there! Clone the packages:

```julia
Pkg.clone("https://github.com/JuliaOpenCV/CVCore")
Pkg.clone("https://github.com/JuliaOpenCV/CVCalib3d")
Pkg.clone("https://github.com/JuliaOpenCV/CVHighGUI")
Pkg.clone("https://github.com/JuliaOpenCV/CVVideoIO")
Pkg.clone("https://github.com/JuliaOpenCV/CVImgProc")
Pkg.clone("https://github.com/JuliaOpenCV/CVImgCodecs")
Pkg.clone("https://github.com/JuliaOpenCV/LibOpenCV")
Pkg.clone("https://github.com/JuliaOpenCV/OpenCV")
```

and then:

```julia
Pkg.build("LibOpenCV")
```

which searches installed opencv shared libraries. If you don't have opencv installed,
`Pkg.build("LibOpenCV")` will try to build and install them into the LibOpenCV package
directory, but not recommended unless if you have perfect requirements to build opencv.

## Test if the installation succeeded

```julia
Pkg.test("OpenCV")
```

If it succeeded, installation is done. If you encounter errors even though all
the previous steps succeeded, please file a bug report.
