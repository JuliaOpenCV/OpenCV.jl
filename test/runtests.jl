using OpenCV
using Base.Test


function test_mat()
    mat = cv2.Mat()
    @test cv2.empty(mat)

    cols, rows = 10, 20
    mat = cv2.Mat(rows, cols, cv2.CV_8U)
    s = size(mat)
    @test cv2.width(s) == cols
    @test cv2.height(s) == rows
    @test cv2.channels(mat) == 1
    @test !cv2.empty(mat)

    mat = cv2.Mat(10, 20, cv2.CV_8UC2)
    @test cv2.channels(mat) == 2

    mat = cv2.Mat(10, 20, cv2.CV_8UC3)
    @test cv2.channels(mat) == 3
end

println("testing cv::Mat")
test_mat()
