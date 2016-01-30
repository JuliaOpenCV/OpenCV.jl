function cvtColor(src::AbstractCvMat, code)
    dst = similar_empty(src)
    icxx"cv::cvtColor($(handle(src)), $(handle(dst)), $code);"
    return dst
end

function resize(src::AbstractCvMat, shape::NTuple{2})
    w, h = shape
    s = cvSize(w, h)
    return resize(src, s)
end

function resize(src::AbstractCvMat, s::cvSize)
    dst = similar_empty(src)
    icxx"cv::resize($(handle(src)), $(handle(dst)), $s);"
    return dst
end

function threshold(src::AbstractCvMat, thresh, maxval, typ)
    dst = similar_empty(src)
    @cxx cv::threshold(handle(src), handle(dst), thresh, maxval, typ)
    return dst
end
