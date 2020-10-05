%Test for the gaussian filter

addpath("G:\Mi unidad\MCC\Primer Semestre\Visión Computacional\Repositorios GIT\Uriel-SIFT\Filtrado");
gf = GaussianFilter(1);
matlabGF = fspecial('gaussian',7,1);

figure()
subplot(1,2,1)
title("Filtro creado por us ")
surf(gf.mask)
title("FIltro matlab")
subplot(1,2,2)
surf(matlabGF)