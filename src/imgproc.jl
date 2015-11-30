function cvtColor(src::Mat, code)
    dst = Mat()
    @cxx cv::cvtColor(src, dst, code)
    return dst
end

function resize(src::Mat, shape::NTuple{2})
    w, h = shape
    s = Size(w, h)
    return resize(src, s)
end

function resize(src::Mat, s::Size)
    dst = Mat()
    @cxx cv::resize(src, dst, s)
    return dst
end

function threshold(src::Mat, thresh, maxval, typ)
    dst = Mat()
    @cxx cv::threshold(src, dst, thresh, maxval, typ)
    return dst
end
