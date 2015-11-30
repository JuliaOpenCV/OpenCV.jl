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

"""cv::Mat_<T>
"""
typealias Mat_{T} cxxt"cv::Mat_<$T>"

Mat() = @cxx cv::Mat()
function Mat(rows, cols, typ)
    @cxx cv::Mat(rows, cols, typ)
end
Mat(m::Mat) = @cxx cv::Mat(m)
function Mat(rows, cols, typ, s::Scalar)
    @cxx cv::Mat(rows, cols, typ, s)
end

clone(m::Mat) = @cxx m->clone()
total(m::Mat) = @cxx m->total()
isContinuous(m::Mat) = @cxx m->isContinuous()
elemSize(m::Mat) = @cxx m->elemSize()
depth(m::Mat) = @cxx m->depth()
channels(m::Mat) = @cxx m->channels()

# TODO: remove this cxx expression
cxx"""cv::Size size(cv::Mat img) { return img.size(); }"""
function Base.size(m::Mat)
    @cxx size(m)
end
empty(m::Mat) = @cxx m->empty()

function copyTo(src::Mat, dst::Mat)
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
