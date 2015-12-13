function imread(name::AbstractString, flag=IMREAD_UNCHANGED)
    Mat(@cxx cv::imread(pointer(name), flag))
end

imwrite(filename::AbstractString, img::Mat) =
    @cxx cv::imwrite(pointer(filename), handle(img))
function imwrite(filename::AbstractString, img::Mat, params)
    @cxx cv::imwrite(pointer(filename), handle(img), params)
end
