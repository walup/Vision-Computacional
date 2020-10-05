addpath("G:\Mi unidad\MCC\Primer Semestre\Visión Computacional\Repositorios GIT\Uriel-SIFT\Filtrado");
img = double(rgb2gray((imread("dalek.jpg"))));
mask = [1 2 1; 0 0 0; -1 -2 -1];
mask2 = [1,0,-1; 2,0,-2;1,0,-1];
filteredImg1 = applyMask(img,mask);
filteredImg2 = applyMask(img,mask2);
gCalc = GradientCalculator(GradientMethods.SOBEL);
[magnitude,direction] = gCalc.obtainGradient(img);
[Gmag,Gdir] = imgradient(img,'sobel');
figure()
subplot(1,2,1)
imshow(Gmag)
subplot(1,2,2)
imshow(Gdir)

figure()
subplot(1,2,1)
imshow(magnitude)
subplot(1,2,2)
imshow(direction)