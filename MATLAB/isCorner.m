% ***Function details***
% **arguments**
% Ix --> Derivative of image at x direction
% Iy --> Derivative of image at y direction
% p --> The pixel that we will check if it is considered as corner
% k --> parameter that is used to calculate R
% Rthres --> parameter that will decide if this pixel is corner
% gauss --> a gauss filter 
% **outputs**
% c --> if c=1 this pixel is corner, else if c=0 is not a corner
% R --> Calculated value of R

function [c, R] = isCorner(Ix, Iy, p, k, Rthres, gauss)
    N = size(gauss,1);
    % CREATE A WINDOW AROUND THE POINT WITH SAME DIMENSIONS AS GAUSS FILTER
    low_limit_x = p(1) - floor(N/2);
    low_limit_y = p(2) - floor(N/2);
    up_limit_x = p(1) + floor(N/2);
    up_limit_y = p(2) + floor(N/2);

    % REJECT THE POINT IF THE WINDOWS GETS OUTSIDE OF THE IMAGE BORDERS
    if up_limit_x > size(Ix,1) || up_limit_y > size(Ix,2) || low_limit_x < 1 || low_limit_y < 1
        c=0;
        R=0;
        return;
    end
    
    % CALCULATE THE FOLLOWING DERIVATIVES OF THE IMAGE BASED ON THIS WINDOW
    Ixx = sum(Ix(low_limit_x:up_limit_x, low_limit_y:up_limit_y).^2.*gauss,'all');
    Iyy = sum(Iy(low_limit_x:up_limit_x, low_limit_y:up_limit_y).^2.*gauss,'all');
    Ixy = sum(Ix(low_limit_x:up_limit_x, low_limit_y:up_limit_y).*Iy(low_limit_x:up_limit_x, low_limit_y:up_limit_y).*gauss,'all');
    
    % APPLY HARRIS METHODOLOGY
    detA = Ixx*Iyy - Ixy^2;
    traceA = Ixx + Iyy;
    R = detA - k*traceA^2;
    
    if R >= Rthres
        c=1;
    else
        c=0;
    end
end