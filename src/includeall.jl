### Include all sources ###

module cv2

const VERBOSE = true

using BinDeps

# Load dependency
deps = joinpath(Pkg.dir("OpenCV"), "deps", "deps.jl")
if isfile(deps)
    include(deps)
else
    error("OpenCV not properly installed. Please run Pkg.build(\"OpenCV\")")
end

VERBOSE && info("Loading Cxx.jl...")
using Cxx

VERBOSE && info("dlopen...")
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

function include_headers(top)
    addHeaderDir(top, kind=C_System)
    addHeaderDir(joinpath(top, "opencv2"), kind=C_System)
    addHeaderDir(joinpath(top, "opencv2", "core"), kind=C_System)
    cxxinclude(joinpath(top, "opencv2/opencv.hpp"))
    cxxinclude(joinpath(top, "opencv2/core/ocl.hpp"))
end


const system_include_top = "/usr/local/include"
const local_include_top = joinpath(Pkg.dir("OpenCV", "deps", "usr", "include"))

if isdir(local_include_top)
    VERBOSE && info("Including headers from local path: $local_include_top")
    include_headers(local_include_top)
elseif isdir(joinpath(system_include_top, "opencv2"))
    VERBOSE && info("Including headers from system path: $system_include_top")
    include_headers(system_include_top)
else
    error("Cannot find OpenCV headers")
end

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
