% ***Function details***
% **arguments**
% I --> Image to apply the local descriptor
% p --> Pixel to apply the local descriptor
% rhom --> the smallest radius, where we will start checking
% rhoM --> the biggest radius, where we will stop checking
% rhostep --> step of the iterator
% N --> number of points checked per iteration
% **outputs**
% d --> List with the local descriptor's results

function d = myLocalDescriptor(I,p,rhom,rhoM,rhostep,N)
    xp = zeros(N,1);
    [m,n,k] = size(I);
    
    % IF I IS RGB, CONVERT IT TO GRAYSCALE
    if k==3
        I=rgb2gray(I);
    end
    
    % CHECK IF CIRCLE'S RADIUS WILL GET OUTSIDE OF IMAGE'S BORDERS
    % IF SO, RETURN AN EMPTY ARRAY
    for i=1:N
        theta = i*2*pi/N;
        x = p(1)+rhoM*cos(theta);
        y = p(2)+rhoM*sin(theta);
        if x < 1 || x >=(m+1) || y < 1 || y>=(n+1)
            d=eye(0);
            return;
        end
    end
    
    % ELSE, INITIALIZE ARRAY WITH SIZE EQUAL TO THE NUMBER OF ITERATIONS
    d = zeros(floor((rhoM-rhom)/rhostep)+1,1);
    count = 0;
    
    % FOR DIFFERENT RADIUS EACH TIME, CALCULATE MEAN VALUE OF THE PIXELS
    % AROUND THE IMAGE
    for rho = rhom:rhostep:rhoM
        count = count + 1;
        for i= 1:N
            theta = i*2*pi/N;
            xp(i) = bilinear_interpolation(I,p(1)+rho*cos(theta),p(2)+rho*sin(theta));
        end
        d(count) =  mean(xp);
    end
end