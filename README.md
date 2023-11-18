# Digital Image Processing: Image Stitching
## Intro
This project is created for the university class named Digital Image Processing at Aristotle University of Thessaloniki (AUTh). It's the first out of three repositories referenced on the same class.

## General

In this work, an attempt was made to implement an application in MATLAB that performs image stitching, which means merging two images that are continuations of each other and have common areas. It also has the capability to rotate one of the two images if needed. The code files (stored in MATLAB folder) are as follows and will be analyzed immediately after the deliverables, as shown in the table of contents:

1. script.m
2. myStitch.m
3. stitchImages.m
4. myDetectHarrisFeatures.m
5. isCorner.m
6. myLocalDescriptor.m
7. myLocalDescriptorUpgrade.m
8. myImgRotation.m
9. getCordsAfterRotation.m
10. bilinear_interpolation.m

Where the term "list" is used, it refers to a one-dimensional array.

## Original Images
The original images that we will use and we will try to stitch on the following steps are presented here:
1. TestIm1.png:

![Test image 1](/images/TestIm1.png)

2. TestIm2.png:

![Test image 2](/images/TestIm2.png)

## Rotation
### Task
Implement the function:

rotImg = myImgRotation(img,angle)

The function, which takes an input image 'img' and rotates it counterclockwise by an angle 'angle' in degrees, should work independently of the number of channels in the input image (e.g., RGB or grayscale). The output image 'rotImg' should have the appropriate dimensions to accommodate the entire input image after rotation. Assume that the background is black.

The idea behind rotating the image is to find the mapping of each pixel in the transformed image with respect to the original input image. For example, instead of saying that the pixel at coordinates (1,1) in the original image corresponds to the pixel at coordinates (3.4, 6.1) in the transformed image, you should do the opposite (i.e., how the pixel at coordinates (1,1) in the transformed image corresponds to the pixel (.4, 1.4) in the original image).

Additionally, consider using bilinear interpolation to calculate the pixel value. Any rounding of pixel coordinates should be rounded down. In the following example, p5 would calculated from the formula:  
p5 = (p2+p4+p6+p8)/4.

|    |          |    |
|----|----------|----|
| p1 | p2       | p3 |
| p4 | **p5=?** | p6 |
| p7 | p8       | p9 |

Show:
1. Rotate the input image TestIm1.png by θ1 = 35 degrees and display the result.
2. Rotate the input image by θ2 = 222 degrees and display the result.

### Implementation
#### Function:
rgb = bilinear_interpolation (img, x, y)

#### Arguments:
* img: The image on which we will apply the bilinear interpolation method
* x, y: The coordinates of the point in the image where we will apply bilinear interpolation

#### Outputs:
• rgb: The result calculated by the function

#### Description:
The function aims to apply linear interpolation without unequal weights in order to calculate the value at a non-integer pixel provided as input. It is purely computational, and in its implementation, all possible cases of coordinates x and y were taken into account.

#### Function:

[rotImg, t1, t2] = myImgRotation (img, angle)

#### Arguments:
* img: The image to be rotated
* angle: The rotation angle, in counterclockwise direction

#### Outputs:
* rotImg: The rotated image
* t1: The vertical translation of the rotated image
* t2: The horizontal translation of the rotated image

#### Description:
The function takes as input an image and rotates it by the angle specified by the argument angle. Initially, we convert the angle from degrees to radians and create the transformation matrix R. We multiply the R matrix by a matrix containing the boundaries of the original image to find the new boundaries. We check if any new boundary has a negative value. If so, we apply a translation equal to the absolute value of the negative coordinate on that axis. The new image will have dimensions equal to the maximum values along each axis of the boundaries, adding t1 and t2 translations.

To color each point of the new image, we need to find its corresponding point in the original image. For this reason, we multiply the coordinates of the point by the inverse of the R matrix. If the coordinates fall within the boundaries of the original image, we have found the correspondence of the point with a point in the original image and call the bilinear_interpolation function, which will return the appropriate value. Otherwise, the value of the point remains 0, indicating a black color, as initialized.

### Results
1. Image: TestIm1.png, Rotation: θ=35 degrees

![Rotated image 1, 35 degrees](/images/rotation1.png)

2. Image: TestIm1.png, Rotation: θ=222 degrees

![Rotated image 1, 222 degrees](/images/rotation2.png)
