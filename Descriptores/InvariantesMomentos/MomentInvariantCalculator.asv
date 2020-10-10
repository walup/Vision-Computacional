classdef MomentInvariantCalculator
   % Obtains some invariants using image moments
   
   methods
       
       function mom = obtainArticleInvariant(obj,img)  
         [x,y] = getCentroid(img);
          m00 = computeMoment(img,0,0,x,y);
          m40  = computeMoment(img,4,0,x,y);
          m04 =  computeMoment(img,0,4,x,y);
          m13 = computeMoment(img,1,3,x,y);
          m31 = computeMoment(img,3,1,x,y);
          m22 = computeMoment(img,2,2,x,y);
          mom = 2*m40*m04-8*m13*m31+6*m22^2;
          mom = mom/m00^(6);
       end
       
  
       function moments = obtainHuMoments(obj,img) 
          moments = [];
          [x,y] = getCentroid(img);
          disp(x);
          disp(y);
          %First Moment
          m20 = computeMoment(img,2,0,x,y);
          m02 = computeMoment(img,0,2,x,y);
          moments = [moments,m20+m02];
          %Second moment
          m11 = computeMoment(img,1,1,x,y);
          moments = [moments,(m20-m02)^2+4*m11^2];
          %Third moment
          m30 =  computeMoment(img,3,0,x,y);
          m12 = computeMoment(img,1,2,x,y);
          m21 = computeMoment(img,2,1,x,y);
          m03 = computeMoment(img,0,3,x,y);
          moments = [moments,(m30-3*m12)^2 + (3*m21-m03)^2];
          %Fourth moment
          moments = [moments,(m30+m12)^2 + (m21 + m03)^2];
          %Fifth moment
          moments = [moments,(m30-3*m12)*(m30+m12)*((m30+m12)^2-3*(m21+m03)^2)+(3*m21-m03)*(m21+m03)*(3*(m30+m12)^2-(m21+m03)^2)];
          %Sixth moment
          moments =[moments, (m20-m02)*((m30+m12)^2-(m21+m03)^2)+4*m11*(m30+m12)*(m21+m03)];
          %Seventh moment
          moments = [moments,(3*m21-m03)*(m30+m12)*((m30+m12)^2-3*(m21+m03)^2)+(m30-3*m12)*(m21+m03)*(3*(m30+m12)^2-(m21+m03)^2)];        
       end
       
       
   end
    
    
    
    
end