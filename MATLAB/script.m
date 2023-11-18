clear
close all
clc

%% GET IMAGES FROM FILES
image1 = imread('images/TestIm1.png');
image2 = imread('images/TestIm2.png');

image1 = double(image1)/255;
image2 = double(image2)/255;

image1_grayscale = rgb2gray(image1);
image2_grayscale = rgb2gray(image2);

%% 1.1.1 ROTATION 
% UNCOMMENT THE FOLLOWING ROWS TO GET IMAGE THAT IS DISPLAYED IN REPORT.PDF

% angle1 = 35;
% [rotImg1,t11,t12] = myImgRotation(image1,angle1);
% figure(3);
% clf;
% imshow(rotImg1);
% title(['Rotation:',num2str(angle1),' degrees']);

%% 1.1.2 ROTATION
% UNCOMMENT THE FOLLOWING ROWS TO GET IMAGE THAT IS DISPLAYED IN REPORT.PDF

% angle2 = 222;
% [rotImg2,t21,t22] = myImgRotation(image1,angle2);
% figure(4);
% clf;
% imshow(rotImg2);
% title(['Rotation:',num2str(angle2),' degrees']);

%% 1.2.1 LOCAL DESCRIPTOR
% UNCOMMENT THE FOLLOWING ROWS TO GET DESCRIPTOR RESULTS FOR SOME POINTS
% WHICH ARE ALREADY INCLUDED IN REPORT.PDF

% p = [100,100];
% p1 = getCordsAfterRotation(p,angle1,t11,t12);
% p2 = getCordsAfterRotation(p,angle2,t21,t22);
% 
% mode = "default";
% printDescriptorResults(image1,rotImg1,rotImg2,p,p1,p2,mode);

%% 1.2.2 UPGRADED LOCAL DESCRIPTOR
% UNCOMMENT THE FOLLOWING ROWS TO GET DESCRIPTOR RESULTS FOR SOME POINTS
% WHICH ARE ALREADY INCLUDED IN REPORT.PDF

% p = [100,100];
% p1 = getCordsAfterRotation(p,angle1,t11,t12);
% p2 = getCordsAfterRotation(p,angle2,t21,t22);
% 
% mode = "upgrade";
% printDescriptorResults(image1,rotImg1,rotImg2,p,p1,p2,mode);

%% 1.3.1 HARRIS CORNER DETECTOR
% UNCOMMENT THE FOLLOWING ROWS TO GET CORNERS OF IMAGE1 AND PLOT THEM
% ALONG WITH THE IMAGE ON THE SCREEN

% I = image1_grayscale;
% corners = myDetectHarrisFeatures(I);
% 
% figure(5);
% imshow(I);
% hold on;
% plot(corners(:,2),corners(:,1),'sr','MarkerSize',5,'MarkerFaceColor','r');
% hold off;

%% 2 IMAGE STITCHING
% IN THE FOLLOWING ROWS WE APPLY THE ASKED IMAGE STITCHING AND AFTER THAT
% WE DISPLAY THE IMAGE ON THE SCREEN

% CHOOSE MODE BETWEEN "default" AND "upgrade"
mode = "upgrade";
Im = myStitch(image1,image2, mode);

figure(1);
imshow(Im);

%% FUNCTIONS
function printDescriptorResults(image,rotImg1,rotImg2,p,p1,p2,mode)
    rhom=5;
    rhoM=20;
    rhostep=1;
    N=8;
    
    if mode=="default"
        d = myLocalDescriptor(image,p,rhom,rhoM,rhostep,N);
        fprintf('Point [%d,%d] of the original image:\n',p(1),p(2));
        for i = 1:size(d,1)
            fprintf("%f ",d(i,1));
        end
        fprintf("\n");
        d1 = myLocalDescriptor(rotImg1,p1,rhom,rhoM,rhostep,N);
        fprintf('Point [%d,%d] of the first rotated image:\n',p1(1),p1(2));
        for i = 1:size(d1,1)
            fprintf("%f ",d1(i,1));
        end
        fprintf("\n");
        d2 = myLocalDescriptor(rotImg2,p2,rhom,rhoM,rhostep,N);
        fprintf('Point [%d,%d] of the second rotated image:\n',p2(1),p2(2));
        for i = 1:size(d2,1)
            fprintf("%f ",d2(i,1));
        end
        fprintf("\n\n\n");

        for i=[200,202]
            q =[i,i];
            d = myLocalDescriptor(image,q,rhom,rhoM,rhostep,N);
            fprintf('Point [%d,%d] of the original image:\n',q(1),q(2));
            for k=1:size(d,1)
                fprintf("%f ",d(k));
            end
            fprintf("\n");
        end
    elseif mode=="upgrade"
        d = myLocalDescriptorUpgrade(image,p,rhom,rhoM,rhostep,N);
        fprintf('Point [%d,%d] of the original image:\n',p(1),p(2));
        for i = 1:3:size(d,1)
            fprintf("%f ",d(i,1));
        end
        fprintf("\n");
        for i = 2:3:size(d,1)
            fprintf("%f ",d(i,1));
        end
        fprintf("\n");
        for i = 3:3:size(d,1)
            fprintf("%f ",d(i,1));
        end
        fprintf("\n");
        d1 = myLocalDescriptorUpgrade(rotImg1,p1,rhom,rhoM,rhostep,N);
        fprintf('Point [%d,%d] of the first rotated image:\n',p1(1),p1(2));
        for i = 1:3:size(d1,1)
            fprintf("%f ",d1(i,1));
        end
        fprintf("\n");
        for i = 2:3:size(d1,1)
            fprintf("%f ",d1(i,1));
        end
        fprintf("\n");
        for i = 3:3:size(d1,1)
            fprintf("%f ",d1(i,1));
        end
        fprintf("\n");
        d2 = myLocalDescriptorUpgrade(rotImg2,p2,rhom,rhoM,rhostep,N);
        fprintf('Point [%d,%d] of the second rotated image:\n',p2(1),p2(2));
        for i = 1:3:size(d2,1)
            fprintf("%f ",d2(i,1));
        end
        fprintf("\n");
        for i = 2:3:size(d2,1)
            fprintf("%f ",d2(i,1));
        end
        fprintf("\n");
        for i = 3:3:size(d2,1)
            fprintf("%f ",d2(i,1));
        end
        fprintf("\n");
        fprintf("\n\n\n");

        for i=[200,202]
            q =[i,i];
            d = myLocalDescriptor(image,q,rhom,rhoM,rhostep,N);
            fprintf('Point [%d,%d] of the original image:\n',q(1),q(2));
            for k=1:size(d,1)
                fprintf("%f ",d(k));
            end
            fprintf("\n\n");
        end
    else
        fprintf("Argument mode works only with values:\nDefault, where default local descriptor is used.\nUpgrade, where upgraded local descriptor is used.");
    end
    fprintf("\n\n\n");
end