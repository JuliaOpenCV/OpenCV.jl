import Base: call, convert, eltype, size

"""cv::Scalar_<T>"""
typealias cvScalar_{T} cxxt"cv::Scalar_<$T>"

"""cv::Scalar"""
const cvScalar = cxxt"cv::Scalar"
cvScalar(v) = @cxx cv::Scalar(v)

typealias AbstractCvScalar Union{cvScalar, cvScalar_}

"""cv::Point_<T>"""
typealias cvPoint_{T} cxxt"cv::Point_<$T>"
call{T}(::Type{cvPoint_{T}}, x, y) = icxx"cv::Point_<$T>($x, $y);"
eltype{T}(p::cvPoint_{T}) = T

"""cv::Point3_<T>"""
typealias cvPoint3_{T} cxxt"cv::Point3_<$T>"
call{T}(::Type{cvPoint3_{T}}, x, y, z) = icxx"cv::Point3_<$T>($x, $y, $z);"
eltype{T}(p::cvPoint3_{T}) = T

"""cv::Point"""
typealias cvPoint cxxt"cv::Point"
cvPoint(x, y) = @cxx cv::Point(x, y)

typealias AbstractCvPoint Union{cvPoint, cvPoint_}

"""cv::Size_<T>"""
typealias cvSize_{T} cxxt"cv::Size_<$T>"
call{T}(::Type{cvSize_{T}}, x, y) = icxx"cv::Size_<$T>($x, $y);"
eltype{T}(s::cvSize_{T}) = T

"""cv::Size"""
typealias cvSize cxxt"cv::Size"
cvSize(x, y) = @cxx cv::Size(x, y)

typealias AbstractCvSize Union{cvSize, cvSize_}

height(s::AbstractCvSize) = Int(@cxx s->height)
width(s::AbstractCvSize) = Int(@cxx s->width)
area(s::AbstractCvSize) = Int(@cxx s->area())

"""Determine julia type from the depth of cv::Mat
"""
function jltype(depth::Int)
    if depth == CV_8U
        return UInt8
    elseif depth == CV_8S
        return Int8
    elseif depth == CV_16U
        return UInt16
    elseif depth == CV_16S
        return Int16
    elseif depth == CV_32S
        return Int32
    elseif depth == CV_32F
        return Float32
    elseif depth == CV_64F
        return Float64
    else
        error("This shouldn't happen")
    end
end

"""Determine cv::Mat depth from Julia type
"""
function cvdepth(T)
    if T == UInt8
        return CV_8U
    elseif T == Int8
        return CV_8S
    elseif T == UInt16
        return CV_16U
    elseif T == Int16
        return CV_16S
    elseif T == Int32
        return CV_32S
    elseif T == Float32
        return CV_32F
    elseif T == Float64
        return CV_64F
    else
        error("$T: not supported in cv::Mat")
    end
end

mat_depth(flags) = flags & CV_MAT_DEPTH_MASK
mat_channel(flags) = (flags & CV_MAT_CN_MASK) >> CV_CN_SHIFT + 1
maketype(depth, cn) = mat_depth(depth) + ((cn-1) << CV_CN_SHIFT)
