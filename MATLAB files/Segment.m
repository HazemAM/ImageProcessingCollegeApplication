function [Segments, NumSegments] = Segment(img)
    %h = fspecial('average', [1,4]);
    %filtered=imfilter(img,h);
    %imshow(filtered);
    %%gram = sum(img,1);
    
    [img,xStart,xEnd,yStart,yEnd,staffStarts,staffSections] = RemoveStaves(img); %SHOULD NOT BE CALLED HERE.
    
    
    %% Pre-processing:
    img = imcomplement(img);

    
    %% Segmenting each block alone:
    img = img(:, xStart:xEnd);
    
    point = [yStart];
    staffLinesNum = size(staffStarts,1);
    staffCount = 1;
    
    while(staffCount <= staffLinesNum/staffSections/5)
        newIndex = 5*staffSections*staffCount;
        searchEnd = newIndex+1;
        if searchEnd > staffLinesNum
            searchEnd = yEnd+10;    %The last block.
        else
            searchEnd = staffStarts(searchEnd);
        end
        
        for i=staffStarts(newIndex):searchEnd
            if sum(img(i,:)) < 5    %Threshold.
                staffCount = staffCount + 1;
                point(staffCount) = i;
                break;
            end
        end
    end
    
    
    %Testing one output:
    %imshow( img(point(1):point(2), :) );
    
    
    %% Separating notes in each block:
    block1 = img(point(1):point(2),:);
    
    CC = bwconncomp(block1);
    NumSegments = CC.NumObjects;
    Segments = regionprops(CC, 'image');
    
    for i=1:NumSegments
       seg = imcomplement(Segments(i).Image);
       [n,m] = size(seg);
       
       if n>5 || m>5
           figure, imshow(seg);
       end
    end

end
