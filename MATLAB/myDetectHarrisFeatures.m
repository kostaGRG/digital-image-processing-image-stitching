% ***Function details***
% **arguments**
% I --> Image to detect the corners
% **outputs**
% corners --> Matrix with the coordinates of all detected corners

function corners = myDetectHarrisFeatures(I)
    count = 0;
    [m,n,~] = size(I);
    
    % INITIALIZE LIST OF CORNERS AND MATRIX OF R VALUES
    corners=zeros(m*n,2);
    R = zeros(size(I));
    
    k = 0.05;
    Rthres = 0.1;
    
%     % Prewitt operator mask
    Mx = [1 0 -1; 1 0 -1; 1 0 -1];
    My = [1 1 1; 0 0 0; -1 -1 -1];

    % Sobel operator mask
%     Mx = [1 0 -1; 2 0 -2; 1 0 -1];
%     My = [1 2 1; 0 0 0; -1 -2 -1];

    % CREATE A GAUSS FILTER THAT WE WILL USE LATER
    sigma = 3;
    N = 4;
    [x,y] = meshgrid(floor(-N/2):floor(N/2), floor(-N/2):floor(N/2));
    gauss=exp(-x.^2/(2*sigma^2)-y.^2/(2*sigma^2));
    gauss = gauss./sum(gauss,'all');
    
    % CALCULATE DERIVATIVES OF THE IMAGE FOR DIRECTIONS X AND Y
    Ix = conv2(I,Mx,'valid');
    Iy = conv2(I,My,'valid');
    
    % CHECK IF EACH PIXEL IS CONSIDERED AS A CORNER
    for i=1:m
        for j=1:n
            [c,R(i,j)] = isCorner(Ix,Iy,[i,j],k,Rthres, gauss);
            if c==1
                count = count+1;
                corners(count,:) = [i,j];
            end
        end
    end
    
    % PRINT MINIMUM AND MAXIMUM R FOR STATISTICAL PURPOSES
    fprintf("minR = %.3f\n",min(R,[],'all'));
    fprintf("maxR = %.3f\n",max(R,[],'all'));
    
    corners = corners(1:count,:);
    fprintf("Corner pixels size: %d\n",size(corners,1));
end