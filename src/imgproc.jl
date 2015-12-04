function cvtColor(src::AbstractMat, code)
    dst = similar_empty(src)
    @cxx cv::cvtColor(src, dst, code)
    return dst
end

function resize(src::AbstractMat, shape::NTuple{2})
    w, h = shape
    s = Size(w, h)
    return resize(src, s)
end

function resize(src::AbstractMat, s::Size)
    dst = similar_empty(src)
    @cxx cv::resize(src, dst, s)
    return dst
end

function threshold(src::AbstractMat, thresh, maxval, typ)
    dst = similar_empty(src)
    @cxx cv::threshold(src, dst, thresh, maxval, typ)
    return dst
end
