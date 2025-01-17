dataMat = load('olivettifaces.mat');

numOfEigensRequired = 32;

facesMat = transpose(dataMat.faces);
size(facesMat)
meanFace = mean(facesMat);
%testImage = double(imresize(imread('bicycle.jpg'),[64 64]));

%testImage = testImage(:,:,1);

testImage = facesMat(350,:);

facesMat = transpose(facesMat - (ones(size(facesMat)) * diag(meanFace)));

covFaces = transpose(facesMat)*facesMat;

[eigenVectorsMat, eigenValuesMat] = eig(covFaces);

eigenVectorsMat = facesMat * eigenVectorsMat;

for eigenVecIndx= 1:1:size(eigenVectorsMat,2)
    eigenVectorsMat(:,eigenVecIndx) = eigenVectorsMat(:,eigenVecIndx)/norm(eigenVectorsMat(:,eigenVecIndx));
end

importantEigens = eigenVectorsMat(:,size(eigenVectorsMat,2)-numOfEigensRequired:size(eigenVectorsMat,2));

projectedData = transpose(facesMat) * importantEigens;

projectedTest = (transpose(testImage(:))-meanFace)*importantEigens;
%imshow(reshape(transpose(testImage(:))-meanFace,[64 64]),[0 255])

reconstructedTest = (importantEigens * projectedTest')+transpose(meanFace); 

figure;
colormap(gray(256));
imagesc(reshape(reconstructedTest,[64 64]));

%{
%The code below is for outputting the eivenvectors
figure;
for iterations = 1:1:numOfEigensRequired
    h = reshape(importantEigens(:,iterations),[64 64]);
    h = imadjust(uint8(255*mat2gray(h)));
    imwrite(h,sprintf('%03s',strcat(num2str(iterations)),'.png'));
end

fileFolder = fullfile('/home','robotichuman','LinearAlgebraPCA');
dirOutput = dir(fullfile(fileFolder,'*.png'));
fileNames = {dirOutput.name};
montage(fileNames,'Size',[numOfEigensRequired/4 4],'DisplayRange', [0 255])
%}

