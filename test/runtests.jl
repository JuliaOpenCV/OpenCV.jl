using OpenCV
using Base.Test

lenapng = joinpath(dirname(@__FILE__), "lena.png")
lenamat = imread(lenapng)
@test size(lenamat) == (512,512,3)
@assert all(!isnan(lenamat))

# From JuliaTokyo #6
@testset "Sobel" begin
    mat = copy(lenamat)
    rows,cols,cn = size(mat)

    grad = Mat{UInt8}()
    grad_x, abs_grad_x= Mat{UInt8}(),Mat{UInt8}()
    grad_y, abs_grad_y= Mat{UInt8}(),Mat{UInt8}()

    mat = resize(mat, (rows/2,cols/2))
    @test size(mat,1) == rows/2
    @test size(mat,2) == cols/2
    @test size(mat,3) == cn

    GaussianBlur!(mat, mat, CVCore.cvSize(3,3), 0, 0)
    gray = cvtColor(mat, COLOR_BGR2GRAY)
    Sobel!(gray, grad_x, CV_16S, 1, 0)
    convertScaleAbs!(grad_x, abs_grad_x)
    Sobel!(gray, grad_y, CV_16S, 0, 1)
    convertScaleAbs!(grad_y, abs_grad_y)
    addWeighted!(abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad)

    @test all(!isnan(grad))
end
