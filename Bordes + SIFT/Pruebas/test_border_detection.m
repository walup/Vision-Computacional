%Test para el detector de bordes como tal 
addpath("G:\Mi unidad\MCC\Primer Semestre\Visión Computacional\Repositorios GIT\Uriel-SIFT\Filtrado");
img = double(rgb2gray((imread("dog.jpg"))));
detector = EdgeDetector(GradientMethods.SOBEL, 0.05);

borderImage = detector.computeEdges(img);
%Vamos a comparar con el metodo ya integrado en matlab
[mag,~] = imgradient(img);
borderImage2 = edge(img,'sobel');

figure()
subplot(1,2,1)
title('Metodo implementado')
imshow(borderImage)
subplot(1,2,2)
title('Metodoi de MATLAB')
imshow(borderImage2)