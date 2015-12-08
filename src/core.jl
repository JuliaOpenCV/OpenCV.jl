import Base: call, convert, eltype, similar, show
import Base: size, getindex, setindex!

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
mat_channel(flags) = flags & CV_MAT_CN_MASK
maketype(depth, cn) = mat_depth(depth) + ((cn-1) << CV_CN_SHIFT)

"""cv::MatExpr
"""
const MatExpr = cxxt"cv::MatExpr"

function size(expr::MatExpr)
    s::Size = @cxx expr->size()
    height(s), width(s)
end

"""cv::Mat
"""
const Mat = cxxt"cv::Mat"

Mat() = @cxx cv::Mat()
Mat(rows, cols, typ) = @cxx cv::Mat(rows, cols, typ)
Mat(rows, cols, typ, s::AbstractScalar) = @cxx cv::Mat(rows, cols, typ, s)
function Mat(rows, cols, typ, data::Ptr, step=0)
    @cxx cv::Mat(rows, cols, typ, data, step)
end
Mat(m::Mat) = @cxx cv::Mat(m)

function eltype(m::Mat)
    cn = channels(m)
    T = jltype(depth(m))
    cn == 1 && return T
    return Vector{T, cn}
end
getindex(m::Mat, i::Int, j::Int) =
    convert(eltype(m), icxx"$m.at<$(eltype(m))>($i-1, $j-1);")
setindex!(m::Mat, v, i::Int, j::Int)= icxx"$m.at<$(eltype(m))>($i-1, $j-1) = $v;"

similar(m::Mat) = Mat(rows(m), cols(m), maketype(depth(m), channels(m)))
similar_empty(m::Mat) = Mat()

"""cv::Mat_<T>
"""
typealias Mat_{T} cxxt"cv::Mat_<$T>"

call{T}(::Type{Mat_{T}}) = icxx"cv::Mat_<$T>();"
call{T}(::Type{Mat_{T}}, rows, cols) = icxx"cv::Mat_<$T>($rows, $cols);"

function call{T}(::Type{Mat_{T}}, rows, cols, data::Ptr, step=0)
    data = convert(Ptr{T}, data)
    icxx"cv::Mat_<$T>($rows, $cols, $data, $step);"
end

eltype{T}(m::Mat_{T}) = T
getindex{T}(m::Mat_{T}, i::Int, j::Int) = convert(T, icxx"$m($i-1, $j-1);")
setindex!(m::Mat_, v, i::Int, j::Int) = icxx"$m($i-1, $j-1) = $v;"

similar{T}(m::Mat_{T}) = Mat_{T}(rows(m), cols(m))
similar_empty{T}(m::Mat_{T}) = Mat_{T}()

import Cxx: CppEnum

# UMatUsageFlags
const USAGE_DEFAULT = CppEnum{symbol("cv::UMatUsageFlags")}(0)
const USAGE_ALLOCATE_HOST_MEMORY = CppEnum{symbol("cv::UMatUsageFlags")}(1 << 0)
const USAGE_ALLOCATE_DEVICE_MEMORY = CppEnum{symbol("cv::UMatUsageFlags")}(1 << 1)
const USAGE_ALLOCATE_SHARED_MEMORY = CppEnum{symbol("cv::UMatUsageFlags")}(1 << 2)
const __UMAT_USAGE_FLAGS_32BIT = CppEnum{symbol("cv::UMatUsageFlags")}(0x7fffffff)

"""cv::UMat
"""
const UMat = cxxt"cv::UMat"

UMat(usage_flags::CppEnum=USAGE_DEFAULT) = @cxx cv::UMat(usage_flags)
function UMat(rows, cols, typ, usage_flags::CppEnum=USAGE_DEFAULT)
    @cxx cv::UMat(rows, cols, typ, usage_flags)
end
function UMat(rows, cols, typ, s::AbstractScalar, usage_flags::CppEnum=USAGE_DEFAULT)
    @cxx cv::UMat(rows, cols, typ, s, usage_flags)
end
UMat(m::Union{Mat, Mat_}, flags=ACCESS_READ) = @cxx m->getUMat(flags)
UMat(m::UMat) = @cxx cv::UMat(m)

# TODO: should avoid copy
similar(m::UMat) = UMat(m)
similar_empty(m::UMat) = UMat()

Mat(m::UMat, flags=ACCESS_READ) = @cxx m->getMat(flags)

elemSize1(m::UMat) = Int(@cxx m->elemSize1())

# TODO: hope Cxx can handle C++ inheritance
typealias AbstractMat Union{Mat, Mat_, UMat}
typealias AbstractMatOrMatExpr Union{AbstractMat, MatExpr}

flags(m::AbstractMat) = icxx"$m.flags;"
dims(m::AbstractMat) = icxx"$m.dims;"
rows(m::AbstractMat) = Int(icxx"$m.rows;")
cols(m::AbstractMat) = Int(icxx"$m.cols;")

_size(m::AbstractMat) = (Int(rows(m)), Int(cols(m)))
function size(m::AbstractMat)
    chan = channels(m)
    if chan == 1
        return _size(m)
    else
        return (Int(rows(m)), Int(cols(m)), chan)
    end
end

jltype(m::AbstractMat) = jltype(Int(depth(m)))
eltype(m::AbstractMat) = jltype(m)

# Note that cv::UMat doesn't have `data` in members.
data(m::Union{Mat, Mat_}) = icxx"$m.data;"

col(m::AbstractMat, i) = icxx"$m.col($i);"
row(m::AbstractMat, i) = icxx"$m.row($i);"

at(m::Union{Mat, Mat_}, T, i, j) = icxx"$m.at<$T>($i, $j);"

clone(m::AbstractMat) = @cxx m->clone()
total(m::AbstractMat) = Int(@cxx m->total())
isContinuous(m::AbstractMat) = @cxx m->isContinuous()
elemSize(m::AbstractMat) = Int(@cxx m->elemSize())
depth(m::AbstractMat) = Int(@cxx m->depth())
channels(m::AbstractMat) = Int(@cxx m->channels())

empty(m::AbstractMat) = @cxx m->empty()

function copyTo(src::AbstractMat, dst::AbstractMat)
    @cxx src->copyTo(dst)
    return dst
end

import Base: +, -, .*, ./, *, /, transpose, inv, ^, min, max

+(x::AbstractMatOrMatExpr, y::AbstractMatOrMatExpr) = @cxx x + y
+(x::AbstractMatOrMatExpr, y::Real) = @cxx x + y
+(x::Real, y::AbstractMatOrMatExpr) = y + x
+(x::AbstractMatOrMatExpr) = x

-(x::AbstractMatOrMatExpr, y::AbstractMatOrMatExpr) = @cxx x - y
-(x::AbstractMatOrMatExpr, y::Real) = @cxx x - y
-(x::Real, y::AbstractMatOrMatExpr) = @cxx x - y
-(x::AbstractMatOrMatExpr) = icxx"-$x;"

.*(x::AbstractMatOrMatExpr, y::Real) = @cxx x * y
.*(x::Real, y::AbstractMatOrMatExpr) = y .* x
*(x::AbstractMatOrMatExpr, y::Real) = x .* y
*(x::Real, y::AbstractMatOrMatExpr) = x .* y
./(x::AbstractMatOrMatExpr, y::Real) = @cxx x / y
./(x::Real, y::AbstractMatOrMatExpr) = @cxx x / y
/(x::AbstractMatOrMatExpr, y::Real) = x ./ y
/(x::Real, y::AbstractMatOrMatExpr) = x ./ y

*(x::AbstractMatOrMatExpr, y::AbstractMatOrMatExpr) = @cxx x * y

transpose(x::AbstractMatOrMatExpr) = icxx"$x.t();"
inv(x::AbstractMatOrMatExpr, method=DECOMP_SVD) = icxx"$x.inv($method);"

min(x::AbstractMat, y::AbstractMat) = icxx"cv::min($x, $y);"
min(x::AbstractMat, y::Real) = icxx"cv::min($x, $y);"
min(x::Real, y::AbstractMat) = icxx"cv::min($x, $y);"
min(x::AbstractMat, y::MatExpr) = min(x, Mat(y))
min(x::MatExpr, y::AbstractMat) = min(Mat(x), y)
min(x::MatExpr, y::MatExpr) = min(Mat(x), Mat(y))
min(x::MatExpr, y::Real) = min(Mat(x), y)
min(x::Real, y::MatExpr) = min(x, Mat(y))

max(x::AbstractMat, y::AbstractMat) = icxx"cv::max($x, $y);"
max(x::AbstractMat, y::Real) = icxx"cv::max($x, $y);"
max(x::Real, y::AbstractMat) = icxx"cv::max($x, $y);"
max(x::AbstractMat, y::MatExpr) = max(x, Mat(y))
max(x::MatExpr, y::AbstractMat) = max(Mat(x), y)
max(x::MatExpr, y::MatExpr) = max(Mat(x), Mat(y))
max(x::MatExpr, y::Real) = max(Mat(x), y)
max(x::Real, y::MatExpr) = max(x, Mat(y))


function Base.zeros(typ, rows, cols)
    @cxx cv::Mat::zeros(rows, cols, typ)
end

function Base.ones(typ, rows, cols)
    @cxx cv::Mat::zeros(rows, cols, typ)
end

function Base.eye(typ, rows, cols)
    @cxx cv::Mat::eye(rows, cols, typ)
end

### Mat to Array{T,N} conversion ###

function convert{T}(::Type{Array{T}}, m::Union{Mat, Mat_})
    p = convert(Ptr{T}, data(m))
    rows, cols = _size(m)
    chan = channels(m)
    arr = pointer_to_array(p, rows*cols*chan)
    if chan == 1
        return reshape(arr, cols, rows)
    else
        return reshape(arr, chan, cols, rows)
    end
end

convert(::Type{Array}, m::Union{Mat, Mat_}) = convert(Array{eltype(m)}, m)
convert(::Type{Array}, m::UMat) = convert(Array, Mat(m))

### Array{T,N} to Mat conversion ###

function convert{T,N}(::Type{Mat}, arr::Array{T,N})
    if N != 2 && N != 3
        error("Not supported conversion")
    end
    depth = cvdepth(T)
    rev_size = reverse(size(arr))
    cn = (N == 2) ? 1 : rev_size[end]
    typ = maketype(depth, cn)
    Mat(rev_size[1], rev_size[2], typ, pointer(arr))
end

function convert{T}(::Type{Mat_{T}}, arr::Matrix{T})
    Mat_{T}(size(arr, 2), size(arr, 1), pointer(arr))
end

convert(::Type{UMat}, arr::Array) = UMat(convert(Mat, arr))

### Mat expression to Mat ###

cxx"""
cv::Mat expr_to_mat(cv::MatExpr& expr) {
    cv::Mat mat(expr);
    return mat;
}
"""
convert(::Type{Mat}, ex::MatExpr) = @cxx expr_to_mat(ex)
convert(::Type{Array}, ex::MatExpr) = convert(Array, Mat(ex))

function _showjlarray(io::IO, arr::Array)
    print(io, "[Julia] ")
    Base.show(io, arr)
end

function show(io::IO, m::Union{Mat, Mat_, UMat})
    print(io, "[C++]   ")
    print(io, string(rows(m), "x", cols(m), " (channel:", channels(m), ") ",
        typeof(m)))
    print(io, "\n")
    _showjlarray(io, transpose(convert(Array, m)))
end

function show(io::IO, expr::MatExpr)
    print(io, "[C++]   ")
    rows, cols = size(expr)
    print(io, string(rows, "x", cols, " ", typeof(expr)))
    print(io, "\n")
    print(io, transpose(convert(Array, expr)))
end
