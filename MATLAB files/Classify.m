function labels  = Classify( img )
imagefiles = dir('*.BMP');
nfiles = 18; 
nClass=7;
padSize=150;
padSizey=50;
images=zeros(nfiles,padSize*padSizey);

for i = 1:nfiles
    currentfilename = imagefiles(i).name;
    temp = imread(currentfilename);
    %temp = im2double(temp);
    temp = rgb2gray(temp);
    temp=im2bw(temp);
    temp=imcomplement(temp);
    temp = imresize(temp,[padSize padSizey]); %resizing image to match with given input
   imshow(temp)
    images(i,:) = temp(:)';
end

%training
SVMModels = cell(6,1);
Y=['1';'1';'1'; '2' ;'2' ;'4' ;'4' ;'b' ;'b' ;'c' ;'c' ;'c' ;'f' ;'f' ;'f' ;'g';'g';'g' ];
classes = unique(Y);
rng(1); % For reproducibility

for j = 1:nClass
    indx=zeros(nfiles,1);
    %indx = strcmp(Y(j),Y); % Create binary classes for each classifier
    for k=1:nfiles
        indx(k) = strcmp(Y(k),classes(j)); % Create binary classes for each classifier
    end
    SVMModels{j} = svmtrain(images,indx);
end





    lb=zeros(nClass,1);
    temp = im2double(img);
    %imshow(temp)
    temp = imresize(temp,[padSize padSizey]);
    %imshow(temp);
    tem = temp(:)';
    for j = 1:nClass;
        lb(j) = svmclassify(SVMModels{j},tem);
    end
% Display the string label
[v,in]=max(lb);
if(v==0)
    labels='n';
else
    labels=char(classes(in));
end

end

