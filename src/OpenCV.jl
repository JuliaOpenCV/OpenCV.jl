__precompile__(false)

"""OpenCV.jl: A Julia wrapper for OpenCV based on Cxx.jl. Note that OpenCV.jl
was started as an experimental project.

## Module cv2

OpenCV.jl only exports the cv2 module, so all types and functions can be
accessed with prefix `cv2.`

## Design notes

- Mat should be a subtype of AbstractArray{T,N}
- Conversion between Mat and Array shouldn't create copy of its internal data
- Utilize Julia's type system
 - Mat{Float64}(rows, cols) is better than Mat(rows, cols, CV_64FC1)
- No types and functions are exported, except for `cv2`
- C++ types of OpenCV should have prefix `cv`. e.g: `cvMat::cxxt"cv::Mat"`

"""
module OpenCV

export cv2

module cv2

const VERBOSE = Bool(parse(Int, get(ENV, "OPENCVJL_VERBOSE", "1")))

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
    "mat",
    "imgcodecs",
    "imgproc",
    "highgui",
    "videoio",
    ]
    include(string(fname, ".jl"))
end

end # module cv2

end # module OpenCV
