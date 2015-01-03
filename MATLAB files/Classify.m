function labels  = Classify( img )
rootFolder = '..\Set';
imgSets = [ imageSet(fullfile(rootFolder, '1')), ...
            imageSet(fullfile(rootFolder, '2')), ...
            imageSet(fullfile(rootFolder, '4'))];%, ...
            %imageSet(fullfile(rootFolder, '8')), ...
            %imageSet(fullfile(rootFolder, '16')) ];
minSetCount = min([imgSets.Count]); % determine the smallest amount of images in a category

% Use partition method to trim the set.
imgSets = partition(imgSets, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
[trainingSets]=imgSets;%, validationSets] = partition(imgSets, 0.3, 'randomize');
bag = bagOfFeatures(trainingSets);
categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);
 %confMatrix = evaluate(categoryClassifier, trainingSets);
 %confMatrix = evaluate(categoryClassifier, validationSets);
% % Compute average accuracy
 %mean(diag(confMatrix));
len=length(img);
labels=zeros(len);
for i=1:len
[labelIdx, ~] = predict(categoryClassifier, img(i).Image);

% Display the string label
labels(i)=categoryClassifier.Labels(labelIdx);
end

end

