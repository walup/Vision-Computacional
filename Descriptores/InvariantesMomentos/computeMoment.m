%Cálcula el momento p, q de la imagen 
function mom = computeMoment(img,p,q, centroidX,centroidY)
[n,m] = size(img);
%Esto lo haremos para que el momento total no sea tan grande
mom = 0;
for i = 1:n
    for j = 1:m
        mom = mom+((j-centroidX)^p)*((i-centroidY)^q)*img(i,j);
    end
end

end