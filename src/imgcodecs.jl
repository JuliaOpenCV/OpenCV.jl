function imread(name::AbstractString, flag=IMREAD_UNCHANGED)
    @cxx cv::imread(pointer(name), flag)
end

imwrite(filename::AbstractString, img) = @cxx cv::imwrite(pointer(filename), img)
function imwrite(filename::AbstractString, img, params)
    @cxx cv::imwrite(pointer(filename), img, params)
end
