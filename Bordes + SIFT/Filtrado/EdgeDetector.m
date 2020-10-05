classdef EdgeDetector < GradientCalculator
    
    properties
        threshold;
    end
    
    methods
        
        function obj = EdgeDetector(method, threshold)
           %Llamamos al constructor del calculador de gradientes
           obj = obj@GradientCalculator(method);
           %El threshold para realizar la detección de bordes 
           obj.threshold = threshold;
        end
        
        function edgeImage = computeEdges(obj,img)
            %Obtenemos el tamaño de la imagen  
            [n,m] = size(img); 
            %Cuadricula de ceros 
            edgeImage = zeros(n,m);
            if(obj.method == GradientMethods.ROBERTS || obj.method == GradientMethods.PREWITT || obj.method == GradientMethods.SOBEL)
                %Obtener el gradiente
                [magnitude,~]= obj.obtainGradient(img);
                maxVal = max(max(magnitude));
                thresholdPoint = obj.threshold*maxVal;
                for i = 1:n
                    for j = 1:m
                        if(magnitude(i,j) > thresholdPoint)
                           edgeImage(i,j) = 255; 
                        end
                    end
                end
            end
        end
        
    end
    
    
end