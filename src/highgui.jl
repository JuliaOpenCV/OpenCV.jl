function imshow(winname::AbstractString, mat::Mat)
    @cxx cv::imshow(pointer(winname), mat)
end

function destroyWindow(winname::AbstractString)
    @cxx cv::destroyWindow(pointer(winname))
end

function destroyAllWindows()
    @cxx cv::destroyAllWindows()
end

function waitKey(;delay::Int=0)
    @cxx cv::waitKey(delay)
end
