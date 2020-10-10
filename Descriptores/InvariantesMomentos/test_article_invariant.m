%Añadimos el path donde se encuentra la imagen 

addpath("G:\Mi unidad\MCC\Primer Semestre\Visión Computacional\Codigos Vision\GitRepository\Vision-Computacional\Bordes + SIFT");
addpath("G:\Mi unidad\MCC\Primer Semestre\Visión Computacional\Codigos Vision\GitRepository\Vision-Computacional\Bordes + SIFT\Explicación del codigo")
addpath("G:\Mi unidad\MCC\Primer Semestre\Visión Computacional\Codigos Vision\GitRepository\Vision-Computacional\Bordes + SIFT\Filtrado")
img = im2double(imread('im.jpg'));

%Creamos nuestro detector de bordes bastante sencillo
edgeDetector  = EdgeDetector(GradientMethods.SOBEL,0.08);
%Obtenemos los bordes de la imagen 
borders = edgeDetector.computeEdges(img);
%Ahora quisiera aislar el monito de android
cropped =double(imcrop(borders));
cropped = cropped/255;
%El objeto calculador de invariantes que implementamos
invCalc = MomentInvariantCalculator();
angles = 0:1:360;
invariantVals = [];
for i = 1:length(angles)
   angle = angles(i);
   rot = imrotate(cropped,angle);
   inv = invCalc.obtainArticleInvariant(rot);
   invariantVals = [invariantVals,inv];
end

figure()
hold on 
title('Gráfico de invariante respecto a ángulo')
xlabel('Ángulo (grados)')
ylabel('Valor del invariante')
plot(angles,invariantVals)
ylim([0.07,0.14])
xlim([0,360])
hold off