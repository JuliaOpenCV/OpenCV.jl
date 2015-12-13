using OpenCV
using Cxx

img = cv2.imread(joinpath(dirname(@__FILE__), "data", "r9y9.jpg"))

@show typeof(img)
@show size(img)

cv2.imshow("Press any key to quit the window", img)
cv2.waitKey(delay=0)
