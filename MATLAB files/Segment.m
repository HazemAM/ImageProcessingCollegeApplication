function [ Segments,NumSegments ] = Segment( img )
h = fspecial('average', [1,4]);
filtered=imfilter(img,h);
imshow(filtered);
 %gram = sum(img,1);
CC = bwconncomp(img);
NumSegments=CC.NumObjects;
Segments=regionprops(CC,'Image');
for i=1:NumSegments
    figure,imshow(Segments(i).Image);
end

end

