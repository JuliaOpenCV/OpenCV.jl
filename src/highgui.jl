function imshow(winname::AbstractString, mat::AbstractCvMat)
    handle = mat.handle
    @cxx cv::imshow(pointer(winname), handle)
end
imshow(winname::AbstractString, arr::Array) = imshow(winname, Mat(arr))
imshow(winname::AbstractString, expr::MatExpr) = imshow(winname, Mat(expr))

destroyWindow(winname::AbstractString) = @cxx cv::destroyWindow(pointer(winname))
destroyAllWindows() = @cxx cv::destroyAllWindows()

waitKey(delay) = @cxx cv::waitKey(delay)
waitKey(;delay::Int=0) = waitKey(delay)
