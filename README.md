# Digital Image Processing: Image Stitching
## Intro
This project is created for the university class named Digital Image Processing at Aristotle University of Thessaloniki (AUTh). It's the first out of three repositories referenced on the same class.

## Tasks
### Function: Rotation
Implement the function:

rotImg = myImgRotation(img,angle)

The function, which takes an input image 'img' and rotates it counterclockwise by an angle 'angle' in degrees, should work independently of the number of channels in the input image (e.g., RGB or grayscale). The output image 'rotImg' should have the appropriate dimensions to accommodate the entire input image after rotation. Assume that the background is black.

The idea behind rotating the image is to find the mapping of each pixel in the transformed image with respect to the original input image. For example, instead of saying that the pixel at coordinates (1,1) in the original image corresponds to the pixel at coordinates (3.4, 6.1) in the transformed image, you should do the opposite (i.e., how the pixel at coordinates (1,1) in the transformed image corresponds to the pixel (.4, 1.4) in the original image).

Additionally, consider using bilinear interpolation to calculate the pixel value. Any rounding of pixel coordinates should be rounded down. In the following example, p5 would calculated from the formula : p5 = (p2+p4+p6+p8)/4.

|    |          |    |
|----|----------|----|
| p1 | p2       | p3 |
| p4 | **p5=?** | p6 |
| p7 | p8       | p9 |
