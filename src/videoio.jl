"""cv::VideoCapture
"""
typealias VideoCapture cxxt"cv::VideoCapture"

VideoCapture(idx::Int) = @cxx cv::VideoCapture(idx)

import Base: read

function read(cap::VideoCapture)
    img = Mat{UInt8}()
    ok = @cxx cap->read(handle(img))
    return ok, img
end

release(cap::VideoCapture) = @cxx cap->release()
