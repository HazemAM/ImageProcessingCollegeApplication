function [newImg,xStart,xEnd,yStart,yEnd,staffStarts,staffSections] = RemoveStaves(img)
    %% Variables and inits.:
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
    yStart = 0;
    yEnd = 0;
    staffStarts = zeros(1,1); %Kinda big to avoid resizing.
    
    %Constants:
    staffErrorHeight = 2; %Assuming staves height-error is up-to 2.
    
    %Temps:
    staffIndex = 1;
    
    
    %% Main staff lines loop:
    for i = staffErrorHeight:m
       theSum = sum(newImg(i,:));
       if theSum >= (peakMax*0.75) && theSum <= (0.98*n) %is it a staff line?
           for j = 1:n
               if i>(staffErrorHeight-1) %Stave pixel confirmed.
                   
                   for x = (i-(staffErrorHeight-1)):i %Checking for smaller staff lines.
                       if newImg(x,j)==1 && newImg(x-1,j)==0 %TODO: Reduce the erosion-like effect.
                            newImg(x,j) = 0; %A pixel part of a stave; delete it.
                            
                            if xStart==0
                               xStart = j; %The start pixel of all staves in X axis.
                            elseif j>xEnd
                                xEnd = j; %The end pixel of all staves in X axis.
                            end
                       end
                   end
                   
                   %Record this as a staff line, if:
                   if ~ismember([i,i-1,i-2],staffStarts) %&& !yStarts.Contains(i). May need efficiency improvements.
                       staffStarts(staffIndex,1) = i;    %Assumptions made that a staff line is 3 or less lines height ([i,i-1,i-2]).
                       staffIndex = staffIndex+1;
                   end
               end
           end
       end
    end
    
    %Detecting staff sections per block:
    staffSections = 2;
    for i=staffStarts(5):staffStarts(6)
       if sum( newImg(i,xStart:xEnd) ) == 0
           staffSections = 1;
           break;
       end
    end
    
    %Detecting the height start:
    for i=staffStarts(1):-1:1
       if sum( newImg(i,xStart:xEnd) ) ~= 0
           yStart = i;
       else
           break;
       end
    end
    
    %Detecting the height end:
    lastStaff = size(staffStarts,1);
    imgHeight = size(newImg,1);
    for i=staffStarts(lastStaff):imgHeight
       if sum( newImg(i,xStart:xEnd) ) ~= 0
           yEnd = i;
       else
           break;
       end
    end
    
    
    %% Post-processing:
    %Back to original colors:
    newImg = imcomplement(newImg);
    
    
    %% TESTING
    
    %Testing sections:
    %display(staffSections);
    
    %Testing Y size:
    %display(size(yStarts));
    
    %Testing Y:
    %for i=1:size(yStarts)
    %   if(yStarts(i)~=0)
    %       newImg(yStarts(i),:) = 0;
    %   end
    %end
    
    %Testing X start and end points:
    %newImg(:,xStart) = 0;
    %newImg(:,xEnd) = 0;
    
    %newImg = newImg(yStart:yEnd, xStart:xEnd);
end
