% ***Function details***
% **arguments**
% img --> Image to apply bilinear interpolation
% x,y --> pixel to apply bilinear interpolation
% **outputs**
% rgb --> result of bilinear interpolation

function rgb = bilinear_interpolation(img,x,y)
    [M,N,~] = size(img);
    if x == floor(x) && y == floor(y)
        rgb = img(x,y,:);
    elseif x == floor(x)
        if floor(y) == N 
            rgb = img(x,N,:);
        else
            rgb = (img(x,floor(y),:)+img(x,floor(y)+1,:))/2;
        end
    elseif y == floor(y)
        if floor(x) == M 
            rgb = img(M,y,:);
        else
            rgb = (img(floor(x),y,:)+img(floor(x)+1,y,:))/2;
        end
    else
        if floor(x) == M && floor(y) == N
            rgb = img(floor(x),floor(y),:);
        elseif floor(x) == M
            rgb = (img(floor(x),floor(y),:) + img(floor(x),floor(y)+1,:))/2;
        elseif floor(y) == N
            rgb = (img(floor(x),floor(y),:) + img(floor(x)+1,floor(y),:))/2;
        else
            x = floor(x);
            y = floor(y);
            rgb = (img(x,y,:)+img(x,y+1,:)+img(x+1,y,:)+img(x+1,y+1,:))/4;
        end
    end
end