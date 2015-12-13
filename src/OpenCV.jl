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

include("includeall.jl")

end # module
