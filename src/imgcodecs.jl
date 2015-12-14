function imread(name::AbstractString, flag=IMREAD_UNCHANGED)
    Mat(@cxx cv::imread(pointer(name), flag))
end

imwrite(filename::AbstractString, img::AbstractCvMat) =
    @cxx cv::imwrite(pointer(filename), handle(img))
imwrite(filename::AbstractString, img::AbstractCvMat, params) =
    @cxx cv::imwrite(pointer(filename), handle(img), params)
