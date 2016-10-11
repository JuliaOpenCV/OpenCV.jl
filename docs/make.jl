using Documenter
using OpenCV

makedocs(
    modules = [OpenCV],
    clean   = false,
    format   = Documenter.Formats.HTML,
    sitename = "OpenCV.jl",
    pages = Any[
        "Home" => "index.md",
        "Installation" => "installation.md",
        "Getting started" => "getting-started.md",
        "Modules" => Any[
            "Core" => "modules/core.md"
            "ImgProc" => "modules/imgproc.md"
            "ImgCodecs" => "modules/imgcodecs.md"
            "VideoIO" => "modules/videoio.md"
            "HighGUI" => "modules/highgui.md"
            "Calib3d" => "modules/calib3d.md"
            "LibOpenCV" => "modules/libopencv.md"
            ]
        ],
)
