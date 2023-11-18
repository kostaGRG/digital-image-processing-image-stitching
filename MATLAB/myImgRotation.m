% ***Function details***
% **arguments**
% img --> Image that will be rotated
% angle --> angle to rotate the image, counterclockwise
% **outputs**
% rotImg --> Rotated image
% t1 --> vertical shift of the image
% t2 --> horizontal shift of the image

function [rotImg,t1,t2] = myImgRotation(img,angle)

    % CONVERT IMAGE FROM DEGREES TO RADIANS
    angle=deg2rad(angle);
    % TRANSFORMATION MATRIX
    R=[cos(angle) -sin(angle);sin(angle) cos(angle)];
    [M,N,d]= size(img);
    edges = [[1;1],[1;N],[M;1],[M;N]];
    % GET EDGES OF THE NEW, ROTATED IMAGE
    A = (R*edges)';
    % T1,T2: VERTICAL/HORIZONTAL SHIFT NEEDED TO BE APPLIED
    t1 = min(A(:,1));
    t2 = min(A(:,2));
    
    if t1 > 0
        t1 = 0;
    end
    if t2 > 0
        t2 = 0;
    end
    
    % INITIALIZE ROTIMG
    newM = floor(max(A(:,1))+abs(t1)) + 1;
    newN = floor(max(A(:,2))+abs(t2)) + 1;
    rotImg = zeros(newM,newN,d);
    
    % FOR EVERY PIXEL OF THE ROTATED IMAGE, FIND OUT ITS COLORS BY MATCHING
    % IT WITH THE CORRESPONDING PIXEL OF THE ORIGINAL IMAGE
    for i = 1:newM
        for j = 1:newN
            point = R\[i-abs(t1);j-abs(t2)];
            point = point + 1;
            if point(1) >= 1 && point(1) < M+1 && point(2) >= 1 && point(2) < N+1
                rotImg(i,j,:) = bilinear_interpolation(img,point(1),point(2));
            end
        end
    end
end