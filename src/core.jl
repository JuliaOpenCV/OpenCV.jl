"""cv::Scalar_<T>
"""
typealias Scalar_{T} cxxt"cv::Scalar_<$T>"

"""cv::Scalar
"""
const Scalar = cxxt"cv::Scalar"
Scalar(v) = @cxx cv::Scalar(v)

"""cv::Mat
"""
const Mat = cxxt"cv::Mat"

Mat() = @cxx cv::Mat()
function Mat(rows, cols, typ)
    @cxx cv::Mat(rows, cols, typ)
end
Mat(m::Mat) = @cxx cv::Mat(m)
function Mat(rows, cols, typ, s::Scalar)
    @cxx cv::Mat(rows, cols, typ, s)
end
function Mat(rows, cols, typ, data::Ptr, step=0)
    @cxx cv::Mat(rows, cols, typ, data, step)
end

"""cv::Mat_<T>
"""
typealias Mat_{T} cxxt"cv::Mat_<$T>"

function Base.call{T}(::Type{Mat_{T}})
    @cxx cv::Mat_()
end
function Base.call{T}(::Type{Mat_{T}}, rows, cols)
    icxx"cv::Mat_<$T>($rows, $cols);"
end
function Base.call{T}(::Type{Mat_{T}}, rows, cols, data::Ptr{T}, step=0)
    icxx"cv::Mat_<$T>($rows, $cols, $data, $step);"
end

function Base.getindex{T}(m::Mat_{T}, i::Int, j::Int)
    icxx"$m.at<$T>($i, $j);"
end

# TODO: hope Cxx can handle C++ inheritance
typealias AbstractMat Union{Mat, Mat_}

flags(m::AbstractMat) = icxx"$m.flags;"
dims(m::AbstractMat) = icxx"$m.dims;"
rows(m::AbstractMat) = icxx"$m.rows;"
cols(m::AbstractMat) = icxx"$m.cols;"
data(m::AbstractMat) = icxx"$m.data;"

col(m::AbstractMat, i) = icxx"$m.col($i);"
row(m::AbstractMat, i) = icxx"$m.row($i);"

function at(m::AbstractMat, T, i, j)
    icxx"$m.at<$T>($i, $j);"
end

clone(m::AbstractMat) = @cxx m->clone()
total(m::AbstractMat) = @cxx m->total()
isContinuous(m::AbstractMat) = @cxx m->isContinuous()
elemSize(m::AbstractMat) = @cxx m->elemSize()
depth(m::AbstractMat) = @cxx m->depth()
channels(m::AbstractMat) = @cxx m->channels()

# TODO: remove this cxx expression
cxx"""cv::Size size(cv::Mat img) { return img.size(); }"""
function Base.size(m::AbstractMat)
    @cxx size(m)
end
empty(m::Mat) = @cxx m->empty()

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

"""cv::Point_<T>
"""
typealias Point_{T} cxxt"cv::Point_<$T>"
"""cv::Point3_<T>
"""
typealias Point3_{T} cxxt"cv::Point3_<$T>"
"""cv::Point
"""
typealias Point cxxt"cv::Point"

Point(x, y) = @cxx cv::Point(x, y)

"""cv::Size_<T>
"""
typealias Size_{T} cxxt"cv::Size_<$T>"
"""cv::Size
"""
typealias Size cxxt"cv::Size"

Size(x, y) = @cxx cv::Size(x, y)

height(s::Size) = @cxx s->height
width(s::Size) = @cxx s->width
