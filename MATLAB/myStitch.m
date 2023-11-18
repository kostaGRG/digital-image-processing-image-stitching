% ***Function details***
% **arguments**
% im1 --> first image to be stitched
% im2 --> second image to be stitched
% mode --> which local descriptor should be used
% **outputs**
% Im --> Final image

function Im = myStitch(im1,im2, mode)
  
    % CHECK IF INPUT IMAGES ARE RGB AND CREATE GRAYSCALE IMAGES 
    if size(im1,3)==3
        im1_gray = rgb2gray(im1);
    else
        im1_gray = im1;
    end
    if size(im2,3)==3
        im2_gray = rgb2gray(im2);
    else
        im2_gray = im2;
    end
    
    % APPLY HARRIS CORNER DETECTOR FOR BOTH IMAGES
    corners1 = myDetectHarrisFeatures(im1_gray);
    disp("<strong>Image 1 harris detector finished.</strong>");
    corners2 = myDetectHarrisFeatures(im2_gray);
    disp("<strong>Image 2 harris detector finished.</strong>");
    corners1_length = size(corners1,1);
    corners2_length = size(corners2,1);
    
    % CHECK IF THERE IS AT LEAST A CORNER IN EACH IMAGE
    if corners1_length < 1 || corners2_length < 1
        disp("<strong>We don't have any corners</strong>");
        Im = eye(0);
        return;
    end
    
   % SEARCH FOR SAME SALIENT POINTS BETWEEN THE 2 IMAGES BASED ON THE LISTS
   % WE GET FROM LOCAL DESCRIPTORS
    count1 = 0;
    count2 = 0;
    
    % ARGUMENTS THAT WE WILL PASS TO LOCAL DESCRIPTOR
    rhom = 4;
    rhoM = 18;
    rhostep = 2;
    
    % THESE ARE LISTS WITH VALUES OF 0. IF A VALUE GET 1, THEN THIS CORNER
    % HAS TO BE REMOVED FROM CORNERS LIST, BECAUSE ITS LOCAL DESCRIPTOR 
    % RETURNS AN EMPTY LIST.
    toDelete1 = zeros(corners1_length,1);
    toDelete2 = zeros(corners2_length,1);
    
    % IF MODE=UPGRADE, WE MAKE USE OF THE UPGRADED LOCAL DESCRIPTOR, ELSE
    % IF MODE=DEFAULT, WE USE THE DEFAULT LOCAL DESCRIPTOR AND IN ANY OTHER
    % CASE PROGRAM EXITS.
    
    if mode=="upgrade"
        % INITIALIZE EMPTY ARRAYS TO STORE LOCAL DESCRIPTOR'S RESULTS.
        d1 = zeros(corners1_length,3*(floor((rhoM-rhom)/rhostep)+1));
        d2 = zeros(corners2_length,3*(floor((rhoM-rhom)/rhostep)+1));
        for i=1:corners1_length
            tmp = myLocalDescriptorUpgrade(im1,corners1(i,:),rhom,rhoM,rhostep,8);
            if isequal(tmp,eye(0))
                toDelete1(i) = 1;
            else
                count1 = count1 + 1;
                d1(count1,:) = tmp;
            end
        end
        
        for i=1:corners2_length
            tmp2 = myLocalDescriptorUpgrade(im2,corners2(i,:),rhom,rhoM,rhostep,8);
            if isequal(tmp2,eye(0))
                toDelete2(i) = 1;
            else
                count2 = count2 + 1;
                d2(count2,:) = tmp2;
            end
        end
        
    d1 = d1(1:count1,:);
    d2 = d2(1:count2,:);
        
    elseif mode=="default"
        % IN THIS CASE, WE FOLLOW A SIMILAR PROCEDURE AS BEFORE.
        d1 = zeros(corners1_length,floor((rhoM-rhom)/rhostep)+1);
        d2 = zeros(corners2_length,floor((rhoM-rhom)/rhostep)+1);
        for i=1:corners1_length
            tmp = myLocalDescriptor(im1_gray,corners1(i,:),rhom,rhoM,rhostep,8);
            if isequal(tmp,eye(0))
                toDelete1(i) = 1;
            else
                count1 = count1 + 1;
                d1(count1,:) = tmp;
            end
        end
        
        for i=1:corners2_length    
            tmp2 = myLocalDescriptor(im2_gray,corners2(i,:),rhom,rhoM,rhostep,8);
            if isequal(tmp2,eye(0))
                toDelete2(i) = 1;
            else
                count2 = count2 + 1;
                d2(count2,:) = tmp2;
            end
        end
        
        d1 = d1(1:count1,:);
        d2 = d2(1:count2,:);
        
    % EXIT IF ARGUMENT MODE HAS A DIFFERENT VALUE
    else
        fprintf("Argument mode works only with values:\nDefault, where default local descriptor is used.\nUpgrade, where upgraded local descriptor is used.");
        Im = eye(0);
        return;
    end
    
    % DELETE CORNERS WITH EMPTY DESCRIPTORS
    corners1(toDelete1 == 1,:) = [];
    corners2(toDelete2 == 1,:) = [];
    
    
    count = 0;
    % DISTANCES: LIST OF DISTANCES BETWEEN THE DESCRIPTORS OF EACH PAIR OF
    % CORNERS BETWEEN THE TWO IMAGES
    % PAIRS: LIST OF INDICES TO FIND OUT THE PIXEL OF EACH IMAGE
    distances = zeros(count1*count2,1);
    pairs = zeros(count1*count2,2);
    
    % CALCULATE DISTANCES FOR EVERY POSSIBLE COMBINATION OF PIXELS BETWEEN
    % THE TWO IMAGES
    for i=1:count1
        for j=1:count2
            distance = abs(d1(i,:)-d2(j,:));
            count = count + 1;
            pairs(count,:) = [i j];
            distances(count) = sum(distance);
        end
    end

    % SORT LIST OF DISTANCES TO GET THE MOST SIMILAR PIXELS BASED ON THEIR
    % DESCRIPTORS.
    [~,index] = sort(distances);
    pairs = pairs(index,:);
    
    % GET THE FIRST number_of_pairs PAIRS FROM THE LIST, THOSE WITH THE
    % SMALLER DISTANCE.
    number_of_pairs = 10;
    pairs = pairs(1:number_of_pairs,:);
    
    % TRANSLATE INDICES TO THE CORRESPONDING PIXELS OF EACH IMAGE AND STORE
    % THEM TO THE FOLLOWING LISTS
    common_pixels = zeros(number_of_pairs,2);
    common_pixels2 = zeros(number_of_pairs,2);
    for i=1:number_of_pairs
        ind1 = pairs(i,1);
        ind2 = pairs(i,2);
        common_pixels(i,:) = corners1(ind1,:);
        common_pixels2(i,:) = corners2(ind2,:);
    end
    
    % CALCULATE ANGLES BETWEEN EACH PAIR OF SEQUENTIAL PIXELS
    angles = zeros(number_of_pairs-1,1);
    for i=1:size(angles,1)
        % INITIALLY FOR THE FIRST IMAGE
        x1 = common_pixels(i,1);
        x2 = common_pixels(i+1,1);
        y1 = common_pixels(i,2);
        y2 = common_pixels(i+1,2);
        if x1==x2 && y1 >= y2
            theta1 = 90;
        elseif x1 == x2 && y1 < y2
            theta1 = -90;
        else
            lambda1 = (y1 - y2)/(x1 - x2);
            theta1 = -rad2deg(atan(lambda1));
        end
        
        % AND NOW FOR THE SECOND IMAGE
        x1 = common_pixels2(i,1);
        x2 = common_pixels2(i+1,1);
        y1 = common_pixels2(i,2);
        y2 = common_pixels2(i+1,2);
        if x1 == x2 && y1 >= y2
            theta2 = 90;
        elseif x1 == x2 && y1 < y2
            theta2 = -90;
        else
            lambda2 = (y1 - y2)/(x1 - x2);
            theta2 = -rad2deg(atan(lambda2));
        end
        angles(i) = theta2 - theta1;
    end
    

    % FOR EACH ANGLE WE CALCULATED, WE WILL CALCULATE HOW MANY PAIRS AGREE
    % WITH THIS CHOICE.(CONSIDERING A POSSIBLE OFFSET AS ACCEPTABLE)
    matches = zeros(size(angles));
    offset = 1;
    for i=1:size(angles,1)
        for j=1:size(angles,1)
            difference = abs(angles(j) - angles(i));
            if difference < offset
                matches(i) = matches(i)+1;
            end
        end
    end

    % CHOOSE THE ANGLE FROM THE PAIR THAT MAXIMIZES TOTAL MATCHES.
    [~,index] = max(matches);
    angle = angles(index);
    fprintf("Angle: %f\n",angle);
    
    % ROTATE SECOND IMAGE USING THE CHOSEN ANGLE.
    [rotIm2,t1,t2] = myImgRotation(im2,angle);
    disp("<strong>Second image rotated.</strong>");
    

    % TRANSFORM COORDINATES OF THE INITIAL IMAGE TO THE ROTATED
    if mod(angle,360) ~= 0
        common_pixels2 = getCordsAfterRotation(common_pixels2,angle,t1,t2);
    end
    
    % PLOT IMAGES WITH THE CORRESPONDING PIXELS
    figure(2);
    sgtitle('COMMON PIXELS');
    subplot(1,2,1);
    imshow(im1);
    hold on;
    plot(common_pixels(:,2),common_pixels(:,1),'sr','MarkerSize',5,'MarkerFaceColor','r');
    hold off;
    subplot(1,2,2);
    imshow(rotIm2);
    hold on
    plot(common_pixels2(:,2),common_pixels2(:,1),'sb','MarkerSize',5,'MarkerFaceColor','b');
    hold off
    
    Im = stitchImages(im1,rotIm2, common_pixels(index,:), common_pixels2(index,:));

end


    
