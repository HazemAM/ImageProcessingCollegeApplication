function [] = OMR(img)
%OMR Summary of this function goes here
%   Detailed explanation goes here
    
    [img,xStart,xEnd,yStart,yEnd,staffStarts,staffSections] = RemoveStaves(img);
    Segment(img,xStart,xEnd,yStart,yEnd,staffStarts,staffSections);

end
