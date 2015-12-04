import Base: similar, size, getindex, .*, ./, *, /
import Cxx: CppEnum

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
function Base.call{T}(::Type{Point_{T}}, x, y)
    icxx"cv::Point_<$T>($x, $y);"
end

"""cv::Point3_<T>
"""
typealias Point3_{T} cxxt"cv::Point3_<$T>"
function Base.call{T}(::Type{Point3_{T}}, x, y, z)
    icxx"cv::Point3_<$T>($x, $y, $z);"
end

"""cv::Point
"""
typealias Point cxxt"cv::Point"
Point(x, y) = @cxx cv::Point(x, y)

typealias AbstractPoint Union{Point, Point_}

"""cv::Size_<T>
"""
typealias Size_{T} cxxt"cv::Size_<$T>"
function Base.call{T}(::Type{Size_{T}}, x, y)
    icxx"cv::Size_<$T>($x, $y);"
end

"""cv::Size
"""
typealias Size cxxt"cv::Size"
Size(x, y) = @cxx cv::Size(x, y)

typealias AbstractSize Union{Size, Size_}

height(s::AbstractSize) = @cxx s->height
width(s::AbstractSize) = @cxx s->width
area(s::AbstractSize) = @cxx s->area()

"""cv::Mat
"""
const Mat = cxxt"cv::Mat"

Mat() = @cxx cv::Mat()
function Mat(rows, cols, typ)
    @cxx cv::Mat(rows, cols, typ)
end
function Mat(rows, cols, typ, s::AbstractScalar)
    @cxx cv::Mat(rows, cols, typ, s)
end
function Mat(rows, cols, typ, data::Ptr, step=0)
    @cxx cv::Mat(rows, cols, typ, data, step)
end
Mat(m::Mat) = @cxx cv::Mat(m)

# TODO: should avoid copy
similar(m::Mat) = Mat(m)
similar_empty(m::Mat) = Mat()

"""cv::Mat_<T>
"""
typealias Mat_{T} cxxt"cv::Mat_<$T>"

Base.call{T}(::Type{Mat_{T}}) = icxx"cv::Mat_<$T>();"
Base.call{T}(::Type{Mat_{T}}, rows, cols) = icxx"cv::Mat_<$T>($rows, $cols);"

function Base.call{T}(::Type{Mat_{T}}, rows, cols, data::Ptr, step=0)
    data = convert(Ptr{T}, data)
    icxx"cv::Mat_<$T>($rows, $cols, $data, $step);"
end

getindex{T}(m::Mat_{T}, i::Int, j::Int) = icxx"$m.at<$T>($i, $j);"

similar{T}(m::Mat_{T}) = Mat_{T}(rows(m), cols(m))
similar_empty{T}(m::Mat_{T}) = Mat_{T}()

# TODO: simpler implentation
function .*{T}(x::Mat_{T}, y::Real)
    mat = Mat_{T}(rows(x), cols(x))
    copyTo(x, mat)
    icxx"""
        for (int i = 0; i < $x.rows; ++i) {
            for (int j = 0; j < $x.cols; ++j) {
                $mat.at<$T>(i, j) = $x.at<$T>(i, j) * $y;
            }
        }
    """
    mat
end

.*(x::Real, y::Mat_) = y .* x
./(x::Mat_, y::Real) = x .* (1.0/y)
*(x::Mat_, y::Real) = x .* y
*(x::Real, y::Mat_) = y * x
/(x::Mat_, y::Real) = x ./ (1.0/y)

# UMatUsageFlags
const USAGE_DEFAULT = CppEnum{symbol("cv::UMatUsageFlags")}(0)
const USAGE_ALLOCATE_HOST_MEMORY = CppEnum{symbol("cv::UMatUsageFlags")}(1 << 0)
const USAGE_ALLOCATE_DEVICE_MEMORY = CppEnum{symbol("cv::UMatUsageFlags")}(1 << 1)
const USAGE_ALLOCATE_SHARED_MEMORY = CppEnum{symbol("cv::UMatUsageFlags")}(1 << 2)
const __UMAT_USAGE_FLAGS_32BIT = CppEnum{symbol("cv::UMatUsageFlags")}(0x7fffffff)

"""cv::UMat
"""
const UMat = cxxt"cv::UMat"

UMat(usage_flags=USAGE_DEFAULT) = @cxx cv::UMat(usage_flags)
function UMat(rows, cols, typ, usage_flags=USAGE_DEFAULT)
    @cxx cv::UMat(rows, cols, typ, usage_flags)
end
function UMat(rows, cols, typ, s::AbstractScalar, usage_flags=USAGE_DEFAULT)
    @cxx cv::UMat(rows, cols, typ, s, usage_flags)
end
UMat(m::Union{Mat, Mat_}, flags=ACCESS_READ) = @cxx m->getUMat(flags)
UMat(m::UMat) = @cxx cv::UMat(m)

# TODO: should avoid copy
similar(m::UMat) = UMat(m)
similar_empty(m::UMat) = UMat()

Mat(m::UMat, flags=ACCESS_READ) = @cxx m->getMat(flags)

elemSize1(m::UMat) = @cxx m->elemSize1()

# TODO: hope Cxx can handle C++ inheritance
typealias AbstractMat Union{Mat, Mat_, UMat}

flags(m::AbstractMat) = icxx"$m.flags;"
dims(m::AbstractMat) = icxx"$m.dims;"
rows(m::AbstractMat) = icxx"$m.rows;"
cols(m::AbstractMat) = icxx"$m.cols;"

Base.size(m::AbstractMat) = (rows(m), cols(m))

# Note that cv::UMat doesn't have `data` in members.
data(m::Union{Mat, Mat_}) = icxx"$m.data;"

col(m::AbstractMat, i) = icxx"$m.col($i);"
row(m::AbstractMat, i) = icxx"$m.row($i);"

function at(m::Union{Mat, Mat_}, T, i, j)
    icxx"$m.at<$T>($i, $j);"
end

clone(m::AbstractMat) = @cxx m->clone()
total(m::AbstractMat) = @cxx m->total()
isContinuous(m::AbstractMat) = @cxx m->isContinuous()
elemSize(m::AbstractMat) = @cxx m->elemSize()
depth(m::AbstractMat) = @cxx m->depth()
channels(m::AbstractMat) = @cxx m->channels()

empty(m::AbstractMat) = @cxx m->empty()

function copyTo(src::AbstractMat, dst::AbstractMat)
    @cxx src->copyTo(dst)
    return dst
end

function Base.zeros(typ, rows, cols)
    @cxx cv::Mat::zeros(rows, cols, typ)
end

function Base.ones(typ, rows, cols)
    @cxx cv::Mat::zeros(rows, cols, typ)
end

function Base.eye(typ, rows, cols)
    @cxx cv::Mat::eye(rows, cols, typ)
end
