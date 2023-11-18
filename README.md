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

#### Function:
new_pixels = getCordsAfterRotation(pixels, angle, t1, t2)

#### Arguments:
* pixels: The points in the image for which we want to calculate the coordinates after rotation
* angle: The rotation angle, counterclockwise
* t1: The vertical translation of the rotated image
* t2: The horizontal translation of the rotated image

#### Outputs:
* new_pixels: Array with the new coordinates of the points

#### Description:
The function aims to take a set of points and calculate the new coordinates they will have after a certain rotation. Initially, the angle is converted from degrees to radians, and the transformation matrix R is calculated. To find the new coordinates, we multiply the matrix R by the pixels and apply the translations t1, t2. Finally, we round down the final values of the pixels that resulted in the new_pixels list.

### Results
1. Image: TestIm1.png, Rotation: θ=35 degrees

![Rotated image 1, 35 degrees](/images/rotation1.png)

2. Image: TestIm1.png, Rotation: θ=222 degrees

![Rotated image 1, 222 degrees](/images/rotation2.png)

## Local Descriptor
### Task

The library starts by creating a routine that implements the calculation of a simple rotation-invariant descriptor for the neighborhood of a point p=[p1,p2]. This particular local descriptor is constructed by scanning successive concentric circles centered at p with radii ρ=ρm:ρs:ρΜ, where both the smallest/largest radius and the step ρs are parameters of the calculation algorithm. The circles are scanned at 2π/N points, and for each of the circles, a vector xρ=[xρ,0,…,xρ,N−1] is calculated. The elements of this vector are computed by interpolating the image elements based on their positions. The basic version of the descriptor is a vector d with as many elements as there are circles (ρM−ρm)/ρs, each of which has a value equal to the average of the corresponding xρ. Construct the function:

function d = myLocalDescriptor(I, p, rhom, rhoM, rhostep, N)

which takes as input a grayscale image I and the values of the parameters rhom,rhoM,rhostep,N, and returns the descriptor vector for the neighborhood of point p. For convenience, it is acceptable for the function to return an empty vector if p is so close to the image boundaries that the largest circle with a radius rhoM extends outside the image.

Construct the function:

function d = myLocalDescriptorUpgrade(I, p, rhom, rhoM, rhostep, N)

In this function, replace the basic version of the descriptor with one of your own design that remains rotation-invariant but contains richer information. It is not necessary for the new descriptor to have the same length as the basic version.

Show:
1. The basic version of the descriptor for pixel p=[100,100] for the initial image "testimg1.png," and for the corresponding pixel after rotation by θ1 and θ2 as mentioned above. The calculations should be done with rhom=5,rhoM=20,rhostep=1,N=8.
2. The basic version of the descriptor for pixels q=[200,200] and q=[202,202] for the initial image "testimg1.png" with the same parameter values.
3. Repeat the above for your own descriptor.

### Implementations
#### Function:
d = myLocalDescriptor(I, p, rhom, rhoM, rhostep, N)

#### Arguments:
* I: The image on which the local descriptor will be applied
* p: The point in the image that we are checking
* rhom: The minimum radius to start the check
* rhoM: The maximum radius to stop the check
* rhostep: The step of the check
* N: The number of points on the circle to calculate per iteration
  
#### Outputs:
* d: A list of values of the local descriptor for the point
  
#### Description:
The function follows the requirements of the assignment. Initially, it checks if the input image is RGB, and if so, it is converted to grayscale. Immediately after that, we check if the points to be selected with the largest radius are within the boundaries of the image. If even one of these points is outside the image boundaries, the function returns an empty array. Otherwise, we initialize an array with a length equal to the number of iterations. In each iteration, we check N points located on the circle with the center at the point of interest and a radius ranging from rhom to rhoM with a step of rhostep. The final value of the descriptor for this point is the average of the N peripheral points of the circle.

#### Function:
d = myLocalDescriptorUpgrade(I, p, rhom, rhoM, rhostep, N)

#### Arguments:
* I: The image on which the local descriptor will be applied
* p: The point in the image that we are checking
* rhom: The minimum radius to start the check
* rhoM: The maximum radius to stop the check
* rhostep: The step of the check
* N: The number of points on the circle to calculate per iteration

#### Outputs:
* d: A list of values of the local descriptor for the point

#### Description:
This function follows exactly the same process and steps as the previous one, with some differences that will be highlighted here. The first difference is that the input image is checked, and it is required to be RGB rather than grayscale since this specific descriptor is an extension of the previous one, returning the average for each radius and for all three colors. Therefore, it has triple the length of the descriptor in the myLocalDescriptor function for the same parameters rhom, rhoM, and rhostep.

### Results
#### MyLocalDescriptor
Right below, there are 3 lists with the values returned by the local descriptor for the point P = [100, 100] for the base image and for the two that have resulted after rotation by angles of 35 and 222 degrees, respectively.

![Local descriptor 1](/images/local_desc1.png)

For the original image we calculate the values of the local descriptor for the points P1=[200,200] and P2=[202,202]:

![Local descriptor 2](/images/local_desc2.png)
![Local descriptor 3](/images/local_desc3.png)

#### MyLocalDescriptorUpgrade
This particular local descriptor is quite similar to the previous one, with the difference that it now returns information for each of the three colors (RGB) of the image separately. Thus, for each point, a descriptor with triple the length is generated, and it is presented in a table below where the number of columns is the same as in the previous descriptor, but now there are 3 rows, one for each color. Making the same experiments as before:

![Local descriptor upgraded 1](/images/local_upgrade1.png)
![Local descriptor upgraded 2](/images/local_upgrade2.png)
![Local descriptor upgraded 3](/images/local_upgraded3.png)
