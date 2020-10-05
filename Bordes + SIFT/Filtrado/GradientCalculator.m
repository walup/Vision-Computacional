%This class obtains the gradient of an image 


classdef GradientCalculator
    
    properties
       maskX;
       maskY;
       method;
    end
    
    methods 
        function obj = GradientCalculator(method)
           obj.method = method; 
           %Mascara del método Roberts
           if(method == GradientMethods.ROBERTS)
               obj.maskY = [-1,0;0,1];
               obj.maskX = [0,-1;1,0];
           %Mascara del método Prewitt
           elseif(method == GradientMethods.PREWITT)
               obj.maskY = [-1,-1,-1;0,0,0; 1,1,1];
               obj.maskX = [-1,0,1;-1,0,1;-1,0,1];
           %Mascara del método Sobel
           elseif(method == GradientMethods.SOBEL)
               obj.maskY = [-1,-2,-1;0,0,0;1,2,1];
               obj.maskX = [-1,0,1;-2,0,2;-1,0,1];
           end
        end
        
        function [magnitude, direction] = obtainGradient(obj,img)
           gx =  applyMask(img,obj.maskX);
           gy = applyMask(img,obj.maskY);
           
           magnitude = sqrt(gx.^2 + gy.^2);
           direction = arrayfun(@(x,y) improvedAtan(y,x),gx,-gy);
        end
        
    end
    
      
end 