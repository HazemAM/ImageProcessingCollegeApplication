function [newImg,xStart,xEnd] = RemoveStaves(img)
    img = rgb2gray(img);
    img = im2double(img); %Work on the double form (MATLAB compatibility issues).
    
    %Thresholding:
    img = im2bw(img, 0.75); %others: graythresh(img) / multithresh(img).
    
    %Get size:
    [m,n] = size(img);
    
    %Making projection:
    gram = uint32(zeros(m,1));
    for i = 1:m
       for j = 1:n
          if img(i,j)==0 %old yaw: <=200
             gram(i) = gram(i)+1;
          end
       end
    end
    
    %Applying:
    peakMax = max(max(gram));
    newImg = imcomplement(img); %Work on the complement, to make the background black.
    xStart = 0;
    xEnd = 0;
    
    for i = 1:m
       theSum = sum(newImg(i,:));
       if theSum >= (peakMax*0.75) && theSum <= (0.98*n)
           for j = 1:n
               if i>1 && newImg(i,j)==1 && newImg(i-1,j)==0 %Stave confirmed.
                   newImg(i,j) = 0; %A pixel part of a stave; delete it.
                   if xStart==0
                       xStart = j; %The start pixel of all staves in X axis.
                   elseif j>xEnd
                       xEnd = j; %The end pixel of all staves in X axis.
                   end
               end
           end
       end
    end
    
    newImg = imcomplement(newImg); %Back to original colors.
    
    %Testing X start and end points:
    %newImg(:,widthStart) = 0;
    %newImg(:,widthEnd) = 0;
end
