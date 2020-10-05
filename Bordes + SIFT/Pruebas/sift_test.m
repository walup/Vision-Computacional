%% Probemos obtener una piramide de DoG
addpath("G:\Mi unidad\MCC\Primer Semestre\Visión Computacional\Repositorios GIT\Uriel-SIFT\SIFT")
octaves = 3;
img = im2double(rgb2gray(imread("dog.jpg")));
sigma = 1.6;
extractor = SIFTExtractor();
pyramid = extractor.obtainGaussianPyramid(img,sigma,octaves);
dogPyramid = extractor.obtainDoGPyramid(pyramid);
%% Una vez hecho la anterior se obtienen las características candidatas de la imagen 
candidates = extractor.obtainKeyPointCandidates(dogPyramid,0);
