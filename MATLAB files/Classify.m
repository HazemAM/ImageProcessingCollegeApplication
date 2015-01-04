function labels  = Classify( img )
%rootFolder = 'Set';
% imgSets = [ imageSet(fullfile(rootFolder, '1')), ...
%             imageSet(fullfile(rootFolder, '2')), ...
%             imageSet(fullfile(rootFolder, '4'))];%, ...
%             %imageSet(fullfile(rootFolder, '8')), ...
%             %imageSet(fullfile(rootFolder, '16')) ];
% minSetCount = min([imgSets.Count]); % determine the smallest amount of images in a category
imagefiles = dir('*.BMP');
nfiles = 11; 
nClass=6;
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
%     s1=size(temp,1);
%     s2=size(temp,2);
%     temp=padarray(temp,[padSize-s1 padSize-s2],'post');
    temp = imresize(temp,[padSize padSizey]);
    %imshow(temp)
    images(i,:) = temp(:)';
end

SVMModels = cell(6,1);
Y=['1'; '2' ;'2' ;'4' ;'4' ;'b' ;'b' ;'f' ;'f' ;'f' ;'g' ];
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
% Use partition method to trim the set.

% Notice that each set now has exactly the same number of images.
%[trainingSets]=imgSets;%, validationSets] = partition(imgSets, 0.3, 'randomize');
%bag = bagOfFeatures(images);
%categoryClassifier = trainImageCategoryClassifier(images, bag);
 %confMatrix = evaluate(categoryClassifier, trainingSets);
 %confMatrix = evaluate(categoryClassifier, validationSets);
% % Compute average accuracy
 %mean(diag(confMatrix));
len=size(img,1);
labels=char(zeros(len,1));

for i=1:len
    lb=zeros(nClass,1);
    temp = im2double(img(i).Image);
    %temp=imcomplement(temp);
    %imshow(temp)
    temp = imresize(temp,[padSize padSizey]);
%     s1=size(temp,1);
%     s2=size(temp,2);
%     temp=padarray(temp,[padSize-s1 padSize-s2],'post');
    %imshow(temp);
    tem = temp(:)';
    for j = 1:nClass;
        lb(j) = svmclassify(SVMModels{j},tem);
    end
% Display the string label
[~,in]=max(lb);
labels(i)=char(classes(in));
end

end

