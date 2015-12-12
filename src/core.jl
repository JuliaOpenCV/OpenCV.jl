import Base: call, convert, eltype, size

"""cv::Scalar_<T>
"""
typealias Scalar_{T} cxxt"cv::Scalar_<$T>"

"""cv::Scalar
"""
const Scalar = cxxt"cv::Scalar"
Scalar(v) = @cxx cv::Scalar(v)

typealias AbstractScalar Union{Scalar, Scalar_}

"""cv::Point_<T>
"""
typealias Point_{T} cxxt"cv::Point_<$T>"
call{T}(::Type{Point_{T}}, x, y) = icxx"cv::Point_<$T>($x, $y);"
eltype{T}(p::Point_{T}) = T

"""cv::Point3_<T>
"""
typealias Point3_{T} cxxt"cv::Point3_<$T>"
call{T}(::Type{Point3_{T}}, x, y, z) = icxx"cv::Point3_<$T>($x, $y, $z);"
eltype{T}(p::Point3_{T}) = T

"""cv::Point
"""
typealias Point cxxt"cv::Point"
Point(x, y) = @cxx cv::Point(x, y)

typealias AbstractPoint Union{Point, Point_}

"""cv::Size_<T>
"""
typealias Size_{T} cxxt"cv::Size_<$T>"
call{T}(::Type{Size_{T}}, x, y) = icxx"cv::Size_<$T>($x, $y);"
eltype{T}(s::Size_{T}) = T

"""cv::Size
"""
typealias Size cxxt"cv::Size"
Size(x, y) = @cxx cv::Size(x, y)

typealias AbstractSize Union{Size, Size_}

height(s::AbstractSize) = Int(@cxx s->height)
width(s::AbstractSize) = Int(@cxx s->width)
area(s::AbstractSize) = Int(@cxx s->area())

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
