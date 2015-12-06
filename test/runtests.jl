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

    @testset "Array to cv::Mat conversion" begin
        arr = rand(Float64, 10, 2)
        m = cv2.Mat(arr)
        @test isa(m, cv2.Mat)
        @test eltype(m) == eltype(arr)
        @test size(arr) == reverse(size(m))
    end
end

@testset "cv::Mat_<T>" begin
    x = ones(Float64, 3, 3)
    mat = cv2.Mat_{Float64}(x)
    @test eltype(mat) == Float64
    @test size(mat) == (3, 3)
end

@testset "cv::UMat" begin
    umat = cv2.UMat(3, 3, cv2.CV_8U)
    mat = cv2.Mat(umat)
    @test isa(mat, cv2.Mat)

    @testset "make sure cv2.resize doesn't change the type of mat" begin
        umat_resized = cv2.resize(umat, (cv2.rows(umat), cv2.cols(umat)))
        @test isa(umat_resized, cv2.UMat)
        @test size(umat) == size(umat_resized)
    end
end

@testset "Mat arithmetic and linear algebra" begin
    x = map(Float64, reshape([1:24;], 2,3*4))
    #=
    2x12 Array{Float64,2}:
     1.0  3.0  5.0  7.0   9.0  11.0  13.0  15.0  17.0  19.0  21.0  23.0
     2.0  4.0  6.0  8.0  10.0  12.0  14.0  16.0  18.0  20.0  22.0  24.0
    =#

    xt = x'
    m = cv2.Mat(xt)
    @test isa(m, cv2.Mat)

    # TODO: should implement .== operator for cv::Mat
    @test x[1,1] == m[1,1]
    @test x[1,2] == m[1,2]

    @testset ".*" begin
        let ret = m .* 5
            @test isa(ret, cv2.MatExpr)
            retmat = cv2.Mat(ret)
            @test Float64(retmat[1,1]) == x[1,1] * 5
        end
    end

    @testset "./" begin
        let ret = m ./ 5
            @test isa(ret, cv2.MatExpr)
            retmat = cv2.Mat(ret)
            @test Float64(retmat[1,1]) == x[1,1] / 5
        end
    end

    @testset "inv" begin
        let retexpr = m * m'
            @test isa(retexpr, cv2.MatExpr)
            retmat = cv2.Mat(retexpr)
            retarr = x * x'
            for j in 1:2, i in 1:2
                @test retmat[i,j] == retarr[i,j]
            end
        end
    end
end
