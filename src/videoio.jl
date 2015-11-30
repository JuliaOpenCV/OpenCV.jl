"""cv::VideoCapture
"""
typealias VideoCapture cxxt"cv::VideoCapture"

function VideoCapture(idx::Int)
    @cxx cv::VideoCapture(idx)
end

function Base.read(cap::VideoCapture)
    img = Mat()
    ok = @cxx cap->read(img)
    return ok, img
end

function release(cap::VideoCapture)
    @cxx cap->release()
end
