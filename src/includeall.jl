### Include all sources ###

module cv2

using BinDeps

# Load dependency
deps = joinpath(Pkg.dir("OpenCV"), "deps", "deps.jl")
if isfile(deps)
    include(deps)
else
    error("OpenCV not properly installed. Please run Pkg.build(\"OpenCV\")")
end

using Cxx

for lib in [
        libopencv_core,
        libopencv_highgui,
        libopencv_imgcodecs,
        libopencv_imgproc,
        libopencv_videoio,
        ]
    p = Libdl.dlopen_e(lib, Libdl.RTLD_GLOBAL)
    p == C_NULL && warn("Failed to load: $lib")
end

cv_include_top = joinpath(Pkg.dir("OpenCV", "deps", "usr", "include"))
addHeaderDir(cv_include_top, kind=C_System)
addHeaderDir(joinpath(cv_include_top, "opencv2"), kind=C_System)
addHeaderDir(joinpath(cv_include_top, "opencv2", "core"), kind=C_System)
cxxinclude(joinpath(cv_include_top, "opencv2/opencv.hpp"))

for fname in [
    "constants",
    "core",
    "imgcodecs",
    "imgproc",
    "highgui",
    "videoio",
    ]
    include(string(fname, ".jl"))
end

end # module cv2
