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
![Local descriptor upgraded 3](/images/local_upgrade3.png)

## Harris Corner Detector
### Task
For the detection of interest points, you will implement the Harris corner detector algorithm, which was first proposed in the article:[Combined corner and edge detector][https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=88cdfbeb78058e0eb2613e79d1818c567f0920e2]. The basic idea is as follows. Let's assume that w(x1,x2) is a two-dimensional function that has non-zero values near the origin and "dies off" as (x1,x2) moves away from (0,0).

Construct the function:

function c = isCorner(I, p, k, Rthres)

which returns logical true/false if the grayscale image I shows a corner at pixel p = [p1, p2]. The input parameter k corresponds to the parameter k from the exercise 7, and the input parameter Rthres defines the threshold above which the value of R(p1, p2) is considered sufficiently positive to detect a corner.

Using this function, construct the function:

function corners = myDetectHarrisFeatures(I)

which implements the algorithm as described above. The variable I is a 2-dimensional array containing a grayscale image with real values in the range [0, 1].

Show:
1. The corners you detected on the grayscale input image by creating a red square of 5 × 5 pixels with each detected corner at the center.

### Implementations
#### Function:
[c, R] = isCorner (Ix, Iy, p, k, Rthres, gauss)

#### Arguments:
* Ix: The partial derivative of the image with respect to the x-axis.
* Iy: The partial derivative of the image with respect to the y-axis.
* p: The point in the image we are checking.
* k: Parameter for calculating R.
* Rthres: Parameter for considering a point as a corner or not.
* gauss: Finite-length Gaussian filter.
  
#### Outputs:
* c: A variable that takes the value 1 if the point is a corner, and 0 if the point is not a corner.
* R: The calculated value of R in the function.

#### Description:
In this function, we follow the procedure defined by the Harris detector. Thus, we create a window of the same size as the applied Gaussian filter and check if the window extends beyond the boundaries of the image. In this case, the function returns. Otherwise, we calculate Ix2, Iy2, and Ixy while applying the Gaussian filter simultaneously and follow the methodology as presented in the assignment.

#### Function:
corners = myDetectHarrisFeatures(I)

#### Arguments:
* I: The grayscale image for which we want to find corner points.

#### Outputs:
* corners: An array containing all the detected corner points.

#### Description:
The function is responsible for detecting corner points (corners) using the Harris Detector. We start by obtaining the dimensions of the image and initializing the "corners" array, where we will store the found corner points, and the "R" array where we will store the "r" values for each point. We also define "Rthres" as the threshold for the "r" value to determine if a point is a corner or not and the parameter "k" that also influences the "r" values. By experimenting with these two parameters, we can control the number of detected corner points.

We also create two masks, Prewitt and Sobel, that can be used to calculate the derivatives in different directions of the image (in this implementation, the Prewitt mask is used). Additionally, we create a finite-length Gaussian window that we will apply to the image later. The filter is computed in this function purely for the purpose of reducing the execution time of the application.

Through convolution with the Prewitt masks mentioned above, we calculate the derivatives Ix and Iy of the image for the two directions. We iterate through all the points in the image and check if they are corner points by calling the "isCorner" function, with arguments including the point, the partial derivatives we calculated, the Gaussian filter we created, and the parameters Rthres and k. We store the points that we consider corners in the "corners" array. Finally, we print the minimum and maximum values of R that were calculated. Generally, the R values are calculated for better implementation, which would read the R values and recalculate Rthres and k to control the number of corner points.

### Results
Harris Corner Detector with parameters Rthres=0.1 and k=0.05:

![Harris corner detector](/images/harris_corner.png)

## Final Problem
### Task
In this section, you will use the functions you have created in this assignment to solve the following problem.

Images im1 and im2 were captured consecutively by a camera that photographed a scene. The goal is to merge them into one image after properly rotating the second image.

Create the function Im = myStitch(im1, im2), which will merge the image im2 into the image im1 after appropriate rotation.

### Implementations
#### Function:
Im = stitchImages(im1, im2, pixel1, pixel2)

#### Arguments:
* im1: The first of the two images we want to merge.
* im2: The second of the two images we want to merge.
* pixel1: The point in the first image where the fusion will take place.
* pixel2: The point in the second image where the fusion will take place.

#### Outputs:
* Im: The final image, where the input images im1 and im2 have been merged.

#### Description:
The function merges the two input images into a final image, creating the fusion at a point chosen as common in both images. Initially, we store the coordinates of the points and the dimensions of the images received as input in new, more user-friendly variables. Note: MATLAB uses unconventional coordinates to display an image. It considers the top-left corner as (0,0), and the point (x, y) is located x units down (i.e., in the x-th row) and y units to the right (i.e., in the y-th column).

We calculate the distances of the points from the bottom border of each image and store them in the variables distanceFromBot1 and distanceFromBot2. The distances from the top border of each image are already known and represented by x1 and x2. All these variables are useful for properly aligning the two images.

We check if the distance of the first point from the top is greater than that of the second point. In this case, we copy the first image into the final image, starting from the upper-left corner. Then, we copy the values of the second image for each point that is to the right of pixel2 and does not have a value of 0 in the final image. Finally, we copy the points of the second image that are to the left of pixel1, but their distance from the new start is greater than distanceFromBot2, and the final image still has a value of 0 at that point to avoid overwriting a point of the first image.

After these three steps, the final image is ready.

#### Function:
Im = myStitch(im1, im2, mode)

#### Arguments:
* im1: The first of the two images we want to stitch.
* im2: The second of the two images we want to stitch.
* mode: A string variable that selects the descriptor to be applied.
If mode = "default", then the original descriptor is used, which is the function myLocalDescriptor.
If mode = "upgrade", then the upgraded descriptor is used, which is the function myLocalDescriptorUpgrade. In any other case, an error message is displayed, explaining that one of the two previous values must be given.

#### Outputs:
* Im: The final image where the input images im1 and im2 have been stitched together.

#### Description:
The function initially checks if the input images are RGB: If they are, it creates grayscale copies.
We call the function myDetectHarrisFeatures with grayscale images as arguments and store the corner points found in the lists corners1 and corners2. We check if either of the two lists is empty, and if so, we display an error message stating that it's impossible to stitch the two images.

Next, we initialize two arrays, d1 and d2, which depend on the selected descriptor and the number of corner points we found. In the case of the upgraded descriptor, the lists have triple the size. For each corner point, we store its local descriptor. We also create two lists of zeros, toDelete1 and toDelete2. If the descriptor of a point is empty, the corresponding position in the toDelete list is set to 1. Once this process is completed for both images, we remove the unnecessary points from the corners1 and corners2 lists.

Now we have the descriptor results for all remaining points. For each possible pair of points between the two images, we calculate the absolute difference of their descriptors and store the result in a list called distances. At the same time, the positions of the pairs in both corners1 and corners2 lists are stored in an array called pairs.

The next step is to sort the values in the distances list in ascending order and rearrange the pairs array accordingly. This way, the pairs with the highest likelihood of matching are at the top of the list. We select the best of these pairs, based on the variable number_of_pairs (which has a value of 10 in the code, meaning we choose the top 10 pairs).
For each value in the pairs array, we find the pixel it points to and create two lists of points, one for each image, called common_pixels and common_pixels2, respectively. Now, we want to find the correct angle, so we chose the first 10 points, not just the first 2, for greater certainty.

We apply the following algorithm: From all the points in the list, we take the first 2 and calculate the tangent of the angle they form. We do the same for the first 2 points in the second image. We handle cases where we have vertical lines separately. To calculate the relative angle between the two images, we subtract the angles of the two images calculated from the inverse tangent. We repeat the above process using the second and third points and continue until we run out of remaining points. The angle calculated at each iteration is stored in a list called angles.

Some of the possible angles we found are correct, while others are not. To find the most suitable one, we create a new list called matches, where for each point, we count how many of the calculated angles are equal to the current one, allowing for a relatively small error (in the code: offset = 1 degree). We select as the appropriate angle the one that had the most matches, which is also printed on the screen.

Now that we have found the angle of the second image relative to the first one, we rotate it by calling the function myImgRotation. Immediately, we update the values of the common_pixels2 list with the new coordinates obtained after rotation, using the getCordsAfterRotation function.

Finally, we display the two images, im1 and the rotated im2, along with the best corner points, and call the stitchImages function, passing these two images and the two points to which the most suitable angle was mapped. The final image is returned to us.

#### File:
script

It is the main file of the program, in which the other functions are called, and the functionality of the application is implemented. First of all, we read the two images that we have as input and save not only the original RGB images but also their grayscale versions.

Next, various sections of code that were used to produce the results of the deliverables presented in this report are provided in the form of comments. To rotate the images, the myImgRotation function is called, and the result is displayed on the screen.

Then, we display the results of the local descriptors for the requested points. To achieve this, we find the coordinates of the initial point in the rotated image by calling the helper function getCordsAfterRotation. To display the results on the console, the printDescriptorResults function has been created, which is presented in this section.

To determine the corner points of the first image, we call the myDetectHarrisFeatures function with the grayscale version of this image as an argument and then display it on the screen along with the selected points.

Finally, the myStitch function is called, where we provide the two images and the descriptor we want to use, and then display the final image on the screen, which is a combination of the two previous images.

#### Function:
printDescriptorResults (image, rotImg1, rotImg2, p, p1, p2, mode)

#### Arguments:
* Image: The image to which the descriptor is applied.
* rotImg1: The first of the two rotated images.
* rotImg2: The second rotated image.
* p: The coordinates of the point where the descriptor is applied in the image.
* p1: The coordinates of the point where the descriptor is applied in rotImg1.
* p2: The coordinates of the point where the descriptor is applied in rotImg2.
* mode: A string variable that selects the descriptor to be applied. If mode = "default," the original descriptor is used, i.e., the myLocalDescriptor function, while if mode = "upgrade," the upgraded descriptor is used, i.e., the myLocalDescriptorUpgrade function. In any other case, an error message is displayed, explaining that one of the two previous values must be given.

#### Description:
The function initializes the variables required to call the appropriate local descriptor. Then, it applies the descriptor to various points required by the statement and prints the results in a readable format on the console.

### Results
For the merging of the two images, the algorithm has several steps that are analyzed in the explanation of the files below. However, it is worth presenting the two images just before their merger, along with the most important pairs of pixels that the algorithm identified as common between the two images. The pixels in the left image are marked in red, while in the right image, they are marked in blue.

![Common Pixels](/images/common_pixels.png)

Next is the image that results after the application is executed, and the images are merged:

![Final image after stitching](/images/stitch.png)

