classdef CoOcurrenceAnalyzer
   properties
       
   end
   
   methods
       %Obtain the co ocurrence matrix for binary image
       function mat = getBinaryCoMatrix(obj,img, offset)
           bwImg = im2bw(img);
           [n,m] = size(bwImg);
           mat = zeros(2,2);
           for i = 1:n
               for j = 1:m
                   if(i+offset(1)<n+1 && j+offset(2)<m+1)
                      valInPixel = bwImg(i,j);
                      valInOffset = bwImg(i+offset(1),j+offset(2));
                      
                      mat(valInPixel+1, valInOffset+1) = mat(valInPixel+1, valInOffset+1) +1;
                   end                   
               end
           end
           
       end
       
   end   
end