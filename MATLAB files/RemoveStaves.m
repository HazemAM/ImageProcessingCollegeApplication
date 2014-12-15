function newImg = RemoveStaves(img)
    img = rgb2gray(img);
    img = im2double(img);
    
    %Thresholding:
    img = im2bw(img, 0.75); %graythresh(img) / multithresh(img)
    
    %Get size:
    [m,n] = size(img);
    
    %Making projection:
    gram = uint32(zeros(m,1));
    for i = 1:m
       for j = 1:n
          if img(i,j)==0 %<=200
             gram(i) = gram(i)+1;
          end
       end
    end
    
    %Testing:
    peakMax = max(max(gram));
    newImg = imcomplement(img);
    widthStart = 0;
    widthEnd = 0;
    
    for i = 1:m
       theSum = sum(newImg(i,:));
       if theSum >= (peakMax*0.75) && theSum <= (0.98*n)
           for j = 1:n
               if i>1 && newImg(i,j)==1 && newImg(i-1,j)==0 %Stave confirmed
                   newImg(i,j) = 0;     %A pixel part of a stave; delete it.
                   if widthStart==0
                       widthStart = j;  %The start pixel of all staves in Y axis
                   elseif j>widthEnd
                       widthEnd = j;
                   end
               end
           end
       end
    end
    
    newImg = imcomplement(newImg);
    newImg(:,widthStart) = 0;
    newImg(:,widthEnd) = 0;
end
