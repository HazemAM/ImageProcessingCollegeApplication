function [ Segments,NumSegments ] = Segment( img )
[m,n] = size(img);
h = fspecial('average', [1,4]);
filtered=imfilter(img,h);
imshow(filtered);
 gram = uint32(zeros(n,1));
    for j = 1:n
       for i = 1:m
          if img(i,j)==0 %old yaw: <=200
             gram(j) = gram(j)+1;
          end
       end
    end
CC = bwconncomp(img);
NumSegments=CC.NumObjects;
Segments=regionprops(CC,'Image');
for i=1:NumSegments
    figure,imshow(Segments(i).Image);
end

end

