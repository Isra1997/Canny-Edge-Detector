function [resut]= mycanny(InputVideo,TOne,TTWo)
    
    % apply a gaussian filter
    GF = fspecial('gaussian',[5 5],1.4);
    FI = imfilter(InputVideo,GF,'same');
    
    % Step 2
  
    % convert to grayscale
    GI=rgb2gray(FI);
    
    % apply the first dervitative edge detector
    [BW,thresh,gv,gh] = edge(GI,'sobel');
 
    % calculate the magnituide of an image
    mag=sqrt((gv.^2)+(gh.^2));

    [m,n]=size(mag);
    OutputF=zeros(m,n);
   
    % Step 3
    % Setting the border of the frames to zeros
    mag(1:m,1)=0;
    mag(1,1:n)=0;
    mag(m,1:n)=0;
    mag(m,1:n)=0;
    
    direction=zeros(m,n);
    for i=2:m-1
        for j=2:n-1
            direction(i,j)=atan2(gv(i,j),gh(i,j))*(180/pi);
            % handeling negative angles
            if(direction(i,j)<0)
                direction(i,j)=360+direction(i,j);
            end
        end
    end
    
    for i=2:m-1
        for j=2:n-1
        % first check
        if((0<=direction(i,j) && direction(i,j)<22.5) || (337.5<=direction(i,j) && direction(i,j)<360))
            if(mag(i,j)>mag(i,j+1) && mag(i,j)>mag(i,j-1))
                 OutputF(i,j)=mag(i,j);
            end
        end
        % secound check
        if((22.5<=direction(i,j) && direction(i,j)<67.5) || (202.5<=direction(i,j) && direction(i,j)<247.5))
            if(mag(i,j)>mag(i-1,j+1) && mag(i,j)>mag(i+1,j-1))
                 OutputF(i,j)=mag(i,j);
            end
        end
        % third check
        if((67.5<=direction(i,j) && direction(i,j)<112.5) || (247.5<=direction(i,j) && direction(i,j)<292.5))
            if(mag(i,j)>mag(i-1,j) && mag(i,j)>mag(i+1,j))
                 OutputF(i,j)=mag(i,j);
            end
        end
        % fourth check
        if((112.5<=direction(i,j) && direction(i,j)<157.5) || (292.5<=direction(i,j) && direction(i,j)<337.5))
            if(mag(i,j)>mag(i-1,j-1) && mag(i,j)>mag(i+1,j+1))
                 OutputF(i,j)=mag(i,j);
            end
        end
        
        end
    end

    resut=zeros(m,n);

    % Step 4
    for i=1:m
        for j=1:n
        if(OutputF(i,j)<TOne)
            resut(i,j)=0;
        elseif(OutputF(i,j)>TTWo)
            resut(i,j)=1;
        elseif(TTWo<OutputF(i,j+1)  || TTWo<OutputF(i-1,j+1) || TTWo<OutputF(i-1,j) || TTWo<OutputF(i-1,j-1) || TTWo<OutputF(i,j-1) || TTWo<OutputF(i+1,j-1) ||TTWo<OutputF(i+1,j) || TTWo<mag(i+1,j+1))
            resut(i,j)=1;
        end

        end
    end
    resut=uint8(resut.*255);
    imshow(resut);
  