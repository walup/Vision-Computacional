%Aplica una mascara la imagen que se de como argumento. 
function filteredImg = applyMask(img,mask)
%El tamaño del filtro
[n,m] = size(mask);
%El tamaño de la imagen 
[imgRows,imgCols] = size(img);
%La mascara debe tener el mismo número de filas y columnas
if(n ~= m)
   error('Las columnas y filas de la mascara a aplicar deben ser iguales');
end
%Estaremos trabajando con mascaras de tamaño impar para que tengan un
%elemento central
if(mod(n,2) == 0)
   error('El tamaño de la mascara debe ser impar, por ejemplo de 3x3'); 
end
%Estaremos añadiendo un borde de ceros a nuestra imagen
centralIndex = (n+1)/2;
borderSize = centralIndex - 1;
imgToFilter = zeros(imgRows+2*borderSize,imgCols+2*borderSize);
%Todo lo que no sea el borde será la imagen como tal 
imgToFilter(borderSize+1:end-borderSize, borderSize+1:end-borderSize) = img;
filteredImg = zeros(imgRows,imgCols);
%Ahora si aplicamos el filtro
[n1,m1] = size(imgToFilter);
for i = borderSize+1:n1-borderSize
    for j = borderSize+1:m1-borderSize        
        imageRow = i - borderSize;
        imageCol = j - borderSize;
        %Ahora si aplicamos la mascara
        value = 0;
        for s = 1:n
            for d = 1:m
                diffRows = s - borderSize;
                diffCols  = d - borderSize;
                value = value+imgToFilter(i+diffRows-1,j+diffCols-1)*mask(s,d);
            end
        end
        filteredImg(imageRow, imageCol) = value;
    end
end
end