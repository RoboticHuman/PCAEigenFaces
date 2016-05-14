dataMat = load('olivettifaces.mat');

numOfEigens =399;

facesMat = dataMat.faces;

[eigenVectors, eigenValues, meanFace] = pc_evectors(facesMat,numOfEigens);
size(eigenVectors)
colormap(gray(256))

OrigImg = facesMat(:,20);

Projection = eigenVectors(:,1:numOfEigens)' * (OrigImg-meanFace);
size((eigenVectors(:,1:numOfEigens) * Projection))
size(meanFace)
Reconstruction = (eigenVectors(:,1:numOfEigens) * Projection)+meanFace;

imagesc(reshape(Reconstruction,[64 64]))