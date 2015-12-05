function imshow(winname::AbstractString, mat::AbstractMat)
    @cxx cv::imshow(pointer(winname), mat)
end

imshow(winname::AbstractString, arr::Array) = imshow(winname, Mat(arr))

function destroyWindow(winname::AbstractString)
    @cxx cv::destroyWindow(pointer(winname))
end

function destroyAllWindows()
    @cxx cv::destroyAllWindows()
end

function waitKey(;delay::Int=0)
    @cxx cv::waitKey(delay)
end
