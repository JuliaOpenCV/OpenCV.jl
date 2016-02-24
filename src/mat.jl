import Base: size, eltype, call, similar, convert, show

"""AbstractCvMat{T,N} represents `N`-dimentional arrays in OpenCV (cv::Mat,
cv::UMat, etc), which element type are bound to `T`.
"""
abstract AbstractCvMat{T,N} <: AbstractArray{T,N}

# NOTE: subtypes of AbstractCvMat should have `handle` as a member.
handle(m::AbstractCvMat) = m.handle


### Types and methods for C++ types ###

const cvMatExpr = cxxt"cv::MatExpr"
function _size(expr::cvMatExpr)
    s::cvSize = icxx"$expr.size();"
    height(s), width(s)
end
_type(m::cvMatExpr) = icxx"$m.type();"
depth(m::cvMatExpr) = mat_depth(_type(m))
channels(m::cvMatExpr) = mat_channel(_type(m))
eltype(m::cvMatExpr) = jltype(depth(m))

const cvMat = cxxt"cv::Mat"
const cvUMat = cxxt"cv::UMat"
typealias cvMatVariants Union{cvMat, cvUMat}

depth(m::cvMatVariants) = convert(Int, icxx"$m.depth();")
channels(m::cvMatVariants) = convert(Int, icxx"$m.channels();")
eltype(m::cvMatVariants) = jltype(depth(m))
dims(m::cvMatVariants) = convert(Int, icxx"$m.dims;")

data(m::cvMat) = icxx"$m.data;"

import Cxx: CppEnum

const UMatUsageFlags = CppEnum{symbol("cv::UMatUsageFlags"),Int32}

const USAGE_DEFAULT = UMatUsageFlags(0)
const USAGE_ALLOCATE_HOST_MEMORY = UMatUsageFlags(1 << 0)
const USAGE_ALLOCATE_DEVICE_MEMORY = UMatUsageFlags(1 << 1)
const USAGE_ALLOCATE_SHARED_MEMORY = UMatUsageFlags(1 << 2)
const __UMAT_USAGE_FLAGS_32BIT = UMatUsageFlags(0x7fffffff)

cvUMat(usage_flags::UMatUsageFlags=USAGE_DEFAULT) = icxx"cv::UMat($usage_flags);"
cvUMat(m::cvUMat) = icxx"cv::UMat($m);"
usageFlags(m::cvUMat) = icxx"$m.usageFlags;"::UMatUsageFlags
elemSize1(m::cvUMat) = convert(Int, icxx"$m.elemSize1();")


### Methods for AbstractCvMat ###

flags(m::AbstractCvMat) = icxx"$(m.handle).flags;"
dims(m::AbstractCvMat) = icxx"$(m.handle).dims;"
rows(m::AbstractCvMat) = convert(Int, icxx"$(m.handle).rows;")
cols(m::AbstractCvMat) = convert(Int, icxx"$(m.handle).cols;")
_size(m::AbstractCvMat) = (Int(rows(m)), Int(cols(m)))

function size(m::Union{AbstractCvMat, cvMatExpr})
    cn = channels(m)
    if cn == 1
        return _size(m)
    else
        return (_size(m)..., cn)
    end
end

clone(m::AbstractCvMat) = icxx"$(m.handle).clone();"
total(m::AbstractCvMat) = convert(Int, icxx"$(m.handle).total();")
isContinuous(m::AbstractCvMat) = icxx"$(m.handle).isContinuous();"
elemSize(m::AbstractCvMat) = convert(Int, icxx"$(m.handle).elemSize();")
depth(m::AbstractCvMat) = convert(Int, icxx"$(m.handle).depth();")
channels(m::AbstractCvMat) = channels(handle(m))
empty(m::AbstractCvMat) = icxx"$(m.handle).empty();"


### MatExpr{T,N} ###

"""MatExpr{T,N} represents cv::MatExpr with encoded type information

`T` and `N` represents the element type and the dimension of Mat,
respectively.

TODO: should consder wherther I make this a subtype of AbstractCvMat{T,N}
"""
type MatExpr{T,N}
    handle::cvMatExpr
end

handle(m::MatExpr) = m.handle
channels(m::MatExpr) = channels(handle(m))
size(m::MatExpr) = size(handle(m))

function (::Type{MatExpr})(handle::cvMatExpr)
    # determin type parameters by value
    T = eltype(handle)
    N = length(size(handle))
    MatExpr{T,N}(handle)
end


"""Mat{T,N} represents cv::Mat with encoded type information

Mat{T,N} keeps cv::Mat instance with: element type `T` and dimention `N`.
Hence, in fact it behaves like cv::Mat_<T>. Note that Mat stores its
internal data in column-major order, while Julia's arrays are in row-major.

NOTE: Mat{T,N} supports multi-channel 2-dimentional matrices and
single-channel 2-dimentional matrices for now. Should be extended for
N-dimentional cases.
"""
type Mat{T,N} <: AbstractCvMat{T,N}
    handle::cvMat
end


### Constructors ###

"""Generic constructor"""
function (::Type{Mat})(handle::cvMat)
    # Determine dimention and element type by value and encode eit into type
    T = eltype(handle)
    cn = channels(handle)
    dims = Int(icxx"$handle.dims;")
    N = (cn == 1) ? dims : dims + 1
    Mat{T,N}(handle)
end

"""Empty mat constructor"""
function (::Type{Mat{T,N}}){T,N}()
    handle = icxx"cv::Mat();"
    Mat{T,N}(handle)
end
function (::Type{Mat{T}}){T}()
    handle = icxx"cv::Mat();"
    Mat{T,2}(handle)
end

"""Single-channel 2-dimentional mat constructor"""
function (::Type{Mat{T}}){T}(rows::Int, cols::Int)
    typ = maketype(cvdepth(T), 1)
    handle = icxx"cv::Mat($rows, $cols, $typ);"
    Mat{T,2}(handle)
end

"""Multi-chanel 2-dimentional mat constructor"""
function (::Type{Mat{T}}){T}(rows::Int, cols::Int, cn::Int)
    typ = maketype(cvdepth(T), cn)
    handle = icxx"cv::Mat($rows, $cols, $typ);"
    Mat{T,3}(handle)
end

"""Single-channel 2-dimentaionl mat constructor with user provided data"""
function (::Type{Mat{T}}){T}(rows::Int, cols::Int, data::Ptr{T}, step=0)
    typ = maketype(cvdepth(T), 1)
    handle = icxx"cv::Mat($rows, $cols, $typ, $data, $step);"
    Mat{T,2}(handle)
end

"""Multi-channel 2-dimentaionl mat constructor with user provided data"""
function (::Type{Mat{T}}){T}(rows::Int, cols::Int, cn::Int, data::Ptr{T},
        step=0)
    typ = maketype(cvdepth(T), cn)
    handle = icxx"cv::Mat($rows, $cols, $typ, $data, $step);"
    Mat{T,3}(handle)
end

(::Type{Mat}){T,N}(m::Mat{T,N}) = Mat{T,N}(m.handle)


### Mat-specific methods ###

Base.linearindexing(m::Mat) = Base.LinearFast()

similar{T}(m::Mat{T}) = Mat{T}(size(m)...)
similar_empty(m::Mat) = similar(m)

# Note that cv::UMat doesn't have `data` in members.
data(m::Mat) = data(m.handle)

import Base: getindex, setindex!

getindex(m::Mat, i::Int) =
    convert(eltype(m), icxx"$(m.handle).at<$(eltype(m))>($i-1);")
getindex(m::Mat, i::Int, j::Int) =
    convert(eltype(m), icxx"$(m.handle).at<$(eltype(m))>($i-1, $j-1);")
function getindex{T}(m::Mat{T}, i::Int, j::Int, k::Int)
    cn = channels(m)
    val::T = 0

    # TODO
    if cn == 2
        val = icxx"$(m.handle).at<cv::Vec<$T,2>>($i-1, $j-1)[$k-1];"
    elseif cn == 3
        val = icxx"$(m.handle).at<cv::Vec<$T,3>>($i-1, $j-1)[$k-1];"
    elseif cn == 4
        val = icxx"$(m.handle).at<cv::Vec<$T,4>>($i-1, $j-1)[$k-1];"
    else
        error("$cn : unsupported channels")
    end

    return val
end

setindex!(m::Mat, v, i::Int) =
    icxx"$(m.handle).at<$(eltype(m))>($i-1) = $v;"
setindex!(m::Mat, v, i::Int, j::Int) =
    icxx"$(m.handle).at<$(eltype(m))>($i-1, $j-1) = $v;"
function setindex!{T}(m::Mat{T}, v, i::Int, j::Int, k::Int)
    cn = channels(m)
    val::T = 0

    if cn == 2
        val = icxx"$(m.handle).at<cv::Vec<$T,2>>($i-1, $j-1)[$k-1] = $v;"
    elseif cn == 3
        val = icxx"$(m.handle).at<cv::Vec<$T,3>>($i-1, $j-1)[$k-1] = $v;"
    elseif cn == 4
        val = icxx"$(m.handle).at<cv::Vec<$T,4>>($i-1, $j-1)[$k-1] = $v;"
    else
        error("$cn : unsupported channels")
    end
end

### UMat{T,N} ###

"""UMat{T,N} represents cv::UMat with encoded type information

`T` and `N` represents the element type and the dimension of Mat,
respectively.
"""
type UMat{T,N} <: AbstractCvMat{T,N}
    handle::cvUMat
end

"""Generic constructor"""
function (::Type{UMat})(handle::UMat)
    # Determine dimention and element type by value and encode eit into type
    T = eltype(handle)
    cn = channels(handle)
    dims = Int(icxx"$handle.dims;")
    N = (cn == 1) ? dims : dims + 1
    UMat{T,N}(handle)
end

"""Empty mat constructor"""
function (::Type{UMat{T}}){T}(;usage_flags::UMatUsageFlags=USAGE_DEFAULT)
    handle = icxx"cv::UMat($usage_flags);"
    UMat{T,0}(handle)
end

"""Single-channel 2-dimentional mat constructor"""
function (::Type{UMat{T}}){T}(rows::Int, cols::Int;
                usage_flags::UMatUsageFlags=USAGE_DEFAULT)
    typ = maketype(cvdepth(T), 1)
    handle = icxx"cv::UMat($rows, $cols, $typ, $usage_flags);"
    UMat{T,2}(handle)
end

"""Multi-chanel 2-dimentional mat constructor"""
function (::Type{UMat{T}}){T}(rows::Int, cols::Int, cn::Int;
                usage_flags::UMatUsageFlags=USAGE_DEFAULT)
    typ = maketype(cvdepth(T), cn)
    handle = icxx"cv::UMat($rows, $cols, $typ, $usage_flags);"
    UMat{T,3}(handle)
end

(::Type{UMat}){T,N}(m::UMat{T,N}) = UMat{T,N}(m.handle)
function (::Type{UMat}){T,N}(m::Mat{T,N}, flags=ACCESS_READ)
    UMat{T,N}(
        icxx"$(m.handle).getUMat($flags);")
end

similar{T}(m::UMat{T}) = UMat{T}(size(m)...)
similar_empty(m::UMat) = similar(m)

# TODO: make it works
show(io::IO, u::UMat) = show(io, convert(Mat, u))


### MatExpr{T,N} to Mat{T,N} conversion ###

convert(::Type{Mat}, m::MatExpr) = Mat(
    icxx"return cv::Mat($(m.handle));")
function show(io::IO, m::MatExpr)
    print(io, string(typeof(m)))
    print(io, "\n")
    show(io, convert(Mat, m))
end


### AbstractCvMat{T,N} to MatExpr{T,N}

convert(::Type{MatExpr}, m::AbstractCvMat) = MatExpr(
    icxx"return cv::MatExpr($(m.handle));")
convert{T,N}(::Type{MatExpr{T,N}}, m::AbstractCvMat{T,N}) = MatExpr{T,N}(
    icxx"return cv::MatExpr($(m.handle));")
convert(::Type{MatExpr}, m::UMat) = convert(MatExpr, convert(Mat, m))
convert{T,N}(::Type{MatExpr{T,N}}, m::UMat{T,N}) = MatExpr{T,N}(
    icxx"return cv::MatExpr($(m.handle));")


### UMat{T,N} to Mat{T,N} conversion ###

convert{T,N}(::Type{Mat}, m::UMat{T,N}, flags=ACCESS_READ) = Mat{T,N}(
    icxx"$(m.handle).getMat($flags);")


### Array{T,N} to Mat conversion ###

function convert{T,N}(::Type{Mat}, arr::Array{T,N})
    if N != 2 && N != 3
        error("Not supported conversion for now")
    end
    Mat{T}(reverse(size(arr))..., pointer(arr))
end


### Mat to Array{T,N} conversion

function convert{T,N}(::Type{Array}, m::Mat{T,N})
    p = convert(Ptr{T}, data(m))
    cn = channels(m)
    arr = pointer_to_array(p, length(m))
    reshape(arr, reverse(size(m))...)
end


### Matrix operations ###

import Base: +, -, .*, ./, *, /, transpose, ctranspose
import Base: promote_rule

promote_rule{T,N}(::Type{Mat{T,N}}, ::Type{MatExpr{T,N}}) = MatExpr{T,N}
promote_rule{T,N}(::Type{UMat{T,N}}, ::Type{MatExpr{T,N}}) = MatExpr{T,N}

macro matexpr(ex)
    if ex.head != :call || length(ex.args) != 3
            error("invalid expression")
    end
    cxxargs = Expr(ex.head, ex.args[1],
        Expr(:call, :handle, esc(ex.args[2])),
        Expr(:call, :handle, esc(ex.args[3])))
    mc = Expr(:macrocall, symbol("@cxx"), cxxargs)
    Expr(:call, :MatExpr, mc)
end

# For convenience
@inline handle(x::Number) = x

# to avoid method ambiguity warnings
for op in [:+, :-, :.*, :./, :*]
    @eval begin
        $op(x::AbstractCvMat{Bool}, y::Bool) = error("not supported")
        $op(x::Bool, y::AbstractCvMat{Bool}) = error("not supported")
    end
end

+(x::MatExpr, y::MatExpr) = @matexpr x + y
+(x::MatExpr, y::Number) = @matexpr x + y
+(x::Number, y::MatExpr) = @matexpr x + y
+(x::MatExpr) = x
+(x::AbstractCvMat) = MatExpr(x)

-(x::MatExpr, y::MatExpr) = @matexpr x - y
-(x::MatExpr, y::Number) = @matexpr x - y
-(x::Number, y::MatExpr) = @matexpr x - y
-(x::MatExpr) = MatExpr(
    icxx"0 - $(x.handle);")
-(x::AbstractCvMat) = -(MatExpr(x))

.*(x::MatExpr, y::MatExpr) = MatExpr(
    icxx"$(x.handle).mul($(y.handle));")
.*(x::MatExpr, y::Number) = @matexpr x * y
.*(x::Number, y::MatExpr) = @matexpr x * y

./(x::MatExpr, y::MatExpr) = @matexpr x / y
./(x::MatExpr, y::Number) = @matexpr x / y
./(x::Number, y::MatExpr) = @matexpr x / y

*(x::MatExpr, y::MatExpr) = @matexpr x * y
*(x::MatExpr, y::Number) = .*(x, y)
*(x::Number, y::MatExpr) = .*(x, y)

/(x::MatExpr, y::Number) = ./(x, y)
/(x::Number, y::MatExpr) = ./(x, y)

# For AbstractCvMats
for op in [:+, :-, :.*, :./, :*]
    @eval begin
        @inline $op(x::AbstractCvMat, y::AbstractCvMat) =
            $op(MatExpr(x), MatExpr(y))
        @inline $op(x::MatExpr, y::AbstractCvMat) = $op(promote(x, y)...)
        @inline $op(x::AbstractCvMat, y::MatExpr) = $op(promote(x, y)...)
    end
end

# Mat and scalars
for op in [:+, :-, :.*, :./, :*]
    @eval begin
        @inline $op(x::AbstractCvMat, y::Number) = $op(MatExpr(x), y)
        @inline $op(x::Number, y::AbstractCvMat) = $op(x, MatExpr(y))
    end
end

transpose(x::MatExpr) = MatExpr(
    icxx"$(x.handle).t();")
transpose(x::AbstractCvMat) = transpose(MatExpr(x))
ctranspose(x::Union{MatExpr, AbstractCvMat}) = transpose(x)


### Linear algebra ###

import Base: inv, ^

inv(x::MatExpr, method=DECOMP_SVD) = MatExpr(
    icxx"$(x.handle).inv($method);")
inv(x::AbstractCvMat, method=DECOMP_SVD) = inv(MatExpr(x), method)

^(x::MatExpr, p::Integer) = (p == -1) ? inv(x) : error("not supported")
^(x::AbstractCvMat, p::Integer) = ^(MatExpr(x), p)
