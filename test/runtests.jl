using OpenCV
using Base.Test


@testset "cv::Mat" begin
    mat = cv2.Mat()
    @test cv2.empty(mat)

    cols, rows = 10, 20
    mat = cv2.Mat(rows, cols, cv2.CV_8U)
    @test size(mat) == (rows, cols)
    @test cv2.channels(mat) == 1
    @test !cv2.empty(mat)

    mat = cv2.Mat(10, 20, cv2.CV_8UC2)
    @test cv2.channels(mat) == 2

    mat = cv2.Mat(10, 20, cv2.CV_8UC3)
    @test cv2.channels(mat) == 3
end

@testset "cv::Mat_<T>" begin
    cols, rows = 10, 20
    mat = cv2.Mat_{Float32}(rows, cols)
    @test eltype(mat) == Float32
    @test size(mat) == (rows, cols)
end

@testset "cv::UMat" begin
    umat = cv2.UMat(20, 20, cv2.CV_8U)
    mat = cv2.Mat(umat)
    @test isa(mat, cv2.Mat)

    @testset "make sure cv2.resize doesn't change the type of mat" begin
        umat_resized = cv2.resize(umat, (cv2.rows(umat), cv2.cols(umat)))
        @test isa(umat_resized, cv2.UMat)
        @test size(umat) == size(umat_resized)
    end
end
