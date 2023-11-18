% ***Function details***
% **arguments**
% pixels --> Pixels to calculate their new coordinates
% angle --> angle that we applied rotation
% t1 --> vertical shift of the rotated image
% t2 --> horizontal shift of the rotated image
% **outputs**
% new_pixels --> Matrix of new coordinates

function new_pixels = getCordsAfterRotation(pixels, angle, t1, t2)
    angle=deg2rad(angle);
    R=[cos(angle) -sin(angle);sin(angle) cos(angle)];
    new_pixels = R * pixels';
    new_pixels = new_pixels';
    new_pixels = new_pixels + abs([t1,t2]);
    new_pixels = floor(new_pixels);
end