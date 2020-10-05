
classdef GaussianFilter
   
    properties
        %La mascara del filtro 
        mask;
        %Esta sería la sigma o desviación estándar del filtro 
        sigma;
        %El tamaño del filtro 
        n;
    end
    
    methods 
        %Crea nuestro filtro gaussiano en base a la sigma que se de como
        %parámetro
        function obj = GaussianFilter(sigma)
            %Por convención generalmente se busca que el filtro abarque 3
            %sigma en cada una de las direcciones.
            obj.sigma = sigma;
            obj.n = 2*ceil(3*sigma)+1;
            [X,Y] = meshgrid(-floor(obj.n/2):floor(obj.n/2),-floor(obj.n/2):floor(obj.n/2));
            obj.mask = (1/(2*pi*sigma^2))*exp((-(X.^2 + Y.^2)/(2*sigma^2)));
            s = sum(sum(obj.mask));
            obj.mask = obj.mask/s; 
        end
    end
    
    
end