% ***Function details***
% **arguments**
% im1 --> first image to be stitched
% im2 --> second image to be stitched
% pixel1 --> pixel of the first image where we will stitch the images
% pixel2 --> pixel of the second image where we will stitch the images
% **outputs**
% Im --> Final image

function Im = stitchImages(im1,im2, pixel1, pixel2)
    % Get pixels' coordinates for both images and size of each image
    x1 = pixel1(1);
    y1 = pixel1(2);
    x2 = pixel2(1);
    y2 = pixel2(2);

    [m1,n1,k1] = size(im1);
    [m2,n2,k2] = size(im2);

    % Calculate distance from bottom of the pixel we will use for stitching
    distanceFromBot1 = m1 - x1;
    distanceFromBot2 = m2 - x2;

    % store coordinates of the new starting point
    new_startX = abs(x1-x2);
    new_startY = abs(y1-y2);
    
    % Initialize a matrix with dimensions that will fit the stitched image
    Im = zeros(max(x1,x2)+max(distanceFromBot1,distanceFromBot2),new_startY+n2,k1);

    % Check which point has bigger distance from the top of the image
    if x1>=x2
        % Copy the first image starting from upper left corner of the final
        % image
        Im(1:m1,1:n1,:) = im1(:,1:n1,:);
        % Copy the second image starting from the new starting point of the
        % final image and only for the pixels that have some value.
        for x =1:m2
            for y = y2+1:n2
                if im2(x,y,:) ~= 0
                    Im(new_startX+x,new_startY+y,:) = im2(x,y,:);
                end
            end
        end
        % Copy the rest of the second image only at the points where we
        % haven't paint yet of the first image.
        if distanceFromBot1 < m2
            for x=distanceFromBot1:m2
                for y= 1:y2
                    if Im(new_startX+x,new_startY+y,:)==0
                        Im(new_startX+x,new_startY+y,:) = im2(x,y,:);
                    end
                end
            end
        end
        
%     elseif x1<x2
%         disp('case 2');
%         Im(new_startX+1:new_startX+m1,1:y1,:) = im1(:,1:y1,:);
%         for x=1:m2
%             for y=y2+1:n2
%                 if im2(x,y,:) ~= 0
%                     Im(x,y+new_startY,:) = im2(x,y,:);
%                 end
%             end
%         end
%     end

    elseif x1<x2
        Im(new_startX+1:new_startX+m1,1:y1,:) = im1(:,1:y1,:);
        Im(1:m2,y1+1:y1+n2-y2,:) = im2(:,y2+1:n2,:);
     
    end

end