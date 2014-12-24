function [newImg,xStart,xEnd,yStart,staffSections] = RemoveStaves(img)
    img = rgb2gray(img);
    img = im2double(img); %Work on the double form (MATLAB compatibility issues).
    
    %%Thresholding:
    img = im2bw(img, 0.75); %others: graythresh(img) / multithresh(img).
    
    %Get size:
    [m,n] = size(img);
    
    %%Making projection:
    gram = sum(img,2);
    
    %Applying:
    peakMax = max(max(gram));
    newImg = imcomplement(img); %Work on the complement, to make the background black.
    
    %%Initializations:
    xStart = 0;
    xEnd = 0;
    yStart = zeros(50,1); %Kinda big to avoid resizing.
    
    %Constants:
    staffErrorHeight = 2; %Assuming staves height-error is up-to 2.
    
    %Temps:
    staffIndex = 1;
    
    
    %%Main staff lines loop:
    for i = staffErrorHeight:m
       theSum = sum(newImg(i,:));
       if theSum >= (peakMax*0.75) && theSum <= (0.98*n)
           for j = 1:n
               if i>(staffErrorHeight-1) %Stave pixel confirmed.
                   
                   for x = (i-(staffErrorHeight-1)):i %Checking for smaller staff lines.
                       if newImg(x,j)==1 && newImg(x-1,j)==0 %TODO: Reduce the erosion-like effect.
                            newImg(x,j) = 0; %A pixel part of a stave; delete it.
                       end
                   end
                   
                   if xStart==0
                       xStart = j; %The start pixel of all staves in X axis.
                   elseif j>xEnd
                       xEnd = j; %The end pixel of all staves in X axis.
                   end
                   
                   %Record this as a staff line, if:
                   if ~ismember([i,i-1,i-2],yStart) %&& !yStart.Contains(i). May need efficiency improvements.
                       yStart(staffIndex,1) = i;    %Assumptions made that a staff line is 3 or less lines height ([i,i-1,i-2]).
                       staffIndex = staffIndex+1;
                   end
               end
           end
       end
    end
    
    staffSections = 2;
    for i=yStart(5):yStart(6)
       if sum( newImg(i,xStart:xEnd) ) == 0
           staffSections = 1;
       end
    end
    
    %Testing sections:
    %display(staffSections);
    
    newImg = imcomplement(newImg); %Back to original colors.
    
    %Testing Y size:
    %display(size(yStart));
    
    %Testing Y:
    %for i=1:size(yStart)
    %    if(yStart(i)~=0)
    %        newImg(yStart(i),:) = 0;
    %    end
    %end
    
    %Testing X start and end points:
    %newImg(:,xStart) = 0;
    %newImg(:,xEnd) = 0;
end
