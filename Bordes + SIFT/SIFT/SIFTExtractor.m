
%Clase para extraer el arreglo de SIFT
classdef SIFTExtractor
    
    properties
        %Imagenes en octava
        s;
        
        
    end
    
    methods
        function obj = SIFTExtractor()
            %Usaremos 5 imágenes por octava por el momento
            obj.s = 5;
        end
        
        %Ok vamos a implementar paso a paso todo lo que se requiere para
        %encontrar las características sift de una imagen. 
        
        %Obtiene la octava para una sigma dada
        function octave = generateOctave(obj,img,sigma)
            %Tamaño de la imagen
            [n,m] = size(img);
            %Arreglo de la octava
            octave = zeros(n,m,obj.s+3);
            for i = 1:obj.s
               octave(:,:,i) = img; 
            end
            k = 2^(1/obj.s);
            filt = GaussianFilter(k*sigma);
            kernel = filt.mask;
            
            for i = 2:obj.s+3
                nextBlur = applyMask(octave(:,:,i-1),kernel);
                octave(:,:,i) = nextBlur;
            end
        end
        
        %Obtiene la piramide completa de octavas
        function pyramid = obtainGaussianPyramid(obj,img,sigma,octaves)
            pyramid = {};
            im = img;
            for i = 1:octaves
               octave = obj.generateOctave(im,sigma);
               %Concatenamos la piramide a la octava
               pyramid{i}= octave;
               %La imagen que usaremos como input para la nueva escala
               im = octave(:,:,end-3);
            end
            disp("Blurred image stack completed")
        end
        
        %Ahora se crea la piramide de diferencias de gaussiana
        function dogPyr = obtainDoGPyramid(obj,pyramid)
           dogPyr = {};
           for i = 1:length(pyramid)
              %Obtenemos la octava i-esima 
              octave = pyramid{i}; 
              %El tamaño de la octava
              [~,~,n] = size(octave);
              dogOctave = [];
              for j = 2:n
                 diff = octave(:,:,j)-octave(:,:,j-1);
                 dogOctave = cat(3,dogOctave,diff);
              end
              %Una vez que ya se recopilaron los DoG de todas las octavas,
              %entonces lo agregamos a la piramide
              dogPyr{i} = dogOctave;
           end
           disp("DoG stack completed")
        end
        
        %El siguiente paso es generar una lista de candidatos para los
        %puntos clave para extraer características.aquí w es el tamaño de
        %la ventana alrededor de la cual obtendremos el máximo
        function candidates = obtainKeyPointCandidates(obj,octave,w)
            w = 16;
            candidates = [];
            [n,m,h] = size(octave);
            %El primer y último niveles se hacen ceros
            octave(:,:,1) = zeros(n,m);
            octave(:,:,end) = zeros(n,m);
            %Ahora si obtenemos posiciones de maximos y minimos
            for j = floor(w/2)+2:n-floor(w/2)
               for k = floor(w/2)+2:m-floor(w/2)
                  for d = 2:h-3
                     maximaExaminingRegion = octave(j-1:j+1,k-1:k+1,d-1:d+1);
                     [~,TMax] = max(maximaExaminingRegion,[],'all','linear');
                     [~,TMin] = min(maximaExaminingRegion,[],'all','linear');
                     %disp(TMax);
                     %if(d == 2 && j == floor(w/2)+2 && k == floor(w/2)+2)
                         %disp([j:j+2;k:k+2;d:d+2]);
                     %end
                     if(TMax == 14 || TMin == 14)
                         candidates = [candidates ; [j,k,d]];
                     end                     
                 end
               end
            end
        end
                
        
        %Function to localize a single key point 
        function [offset,grad,subH,x,y,s] = localizeKeypoint(obj,D,x,y,s)
            %Obtain the partial derivatives (gradient) with respect to x, y
            %and the scale
            dx = (D(y,x+1,s)-D(y,x-1,s))/2;
            dy = (D(y+1,x,s)-D(y-1,x,s))/2;
            ds = (D(y,x,s+1)-D(y,x,s-1))/2;
            
            %Obtain the second derivatives dxx, dxy, dxs dyy dys dss
            dxx = D(y,x+1,s)-2*D(y,x,s)+D(y,x-1,s); 
            dxy = ((D(y+1,x+1,s)-D(y+1,x-1,s)) - (D(y-1,x+1,s)-D(y-1,x-1,s)))/4;
            dxs = ((D(y,x+1,s+1)-D(y,x-1,s+1)) - (D(y,x+1,s-1)-D(y,x-1,s-1)))/4;
            dyy = D(y+1,x,s)-2*D(y,x,s)+D(y-1,x,s);
            dys = ((D(y+1,x,s+1)-D(y-1,x,s+1)) - (D(y+1,x,s-1)-D(y-1,x,s-1)))/4;
            dss = D(y,x,s+1)-2*D(y,x,s)+D(y,x,s-1);
            
            grad = [dx ;dy; ds];
            H = [dxx,dxy,dxs; dxy,dyy,dys;dxs,dys,dss];
            subH = H(1:2,1:2);
            %offset that we would need to add to the vector
            offset = -inv(H)*grad;
        end
        
        %Values from the paper for the intenstity and corner threshold are
        %0.03 and (10+1)^2/10
        function keyPoints = findKeypointsForDogOctave(obj,octave,intensityThreshold,cornerThreshold,w)
            %Se obtienen los candidatos a ser key points de la octava
            candidates = obj.obtainKeyPointCandidates(octave,w);
            keyPoints = [];
            [n,~] = size(candidates);
            for i = 1:n
               %Get the candidate 
               candidate = candidates(i,:);
               %obtain the coordinates of the candidate
               
               y = candidate(1);
               x = candidate(2);
               z = candidate(3);
               
               [offset,grad,subH,x,y,z] = obj.localizeKeypoint(octave,x,y,z);
               %If the pixel value is less than the intensity threshold we
               %will ignore it 
               contrast = octave(y,x,z) +0.5*grad'*offset;
               if(abs(contrast)<intensityThreshold)
                  continue; 
               end
               
               eigen =eig(subH);
               r = eigen(2)/eigen(1);
               R = ((r+1)^2)/r;
               if(R > cornerThreshold)
                  continue; 
               end
               
               kp = [x;y;z]+offset;
               keyPoints = [keyPoints;kp'];
            end 
        end
        
        %Function to obtain the keypoints for the whole pyramid
        function keyPoints = findKeypointsForPyramid(obj,pyramid,intensityThreshold,cornerThreshold,w)
            keyPoints = [];
            
            for i = 1:length(pyramid)
               octave = pyramid{i}; 
               octaveKeypoints = obj.findKeypointsForDogOctave(octave, intensityThreshold,cornerThreshold,w);
               keyPoints = [keyPoints;octaveKeypoints]; 
            end
        end
        
        %Now we can finally move on to the orientation assignment
        function newKps = assignOrientation(obj,kps,octave)
            newKps = [];
            %Ten degrees per bin
            bins = 36;
            binSize = 360/bins;
            [n,~] = size(kps);
            [~,~,octSize] = size(octave);
            
            for i = 1:n
               kp = kps(i);
               %Obtain the coordinates
               cx = uint16(kp(1));
               cy  = uint16(kp(2));
               sc = uint16(kp(3));
               
               if(sc > 0 && sc <octSize-1)
                   sc = sc;
               else
                   sc = octSize;
               end
               
               sigma = kp(3)*1.5;
               w = uint16(2*ceil(sigma+1));
               kernel = GaussianFilter(sigma);
               kernel = kernel.mask;
               %Obtendriamos la imagen que corresponde a la escala en la
               %que se encuentra el keypoint
               L = octave(:,:,sc);
               %Empezamos a crear lo que será nuestro histograma
               hist = zeros(1,bins);
               %Tambien creamos un calculador de gradientes, ya que lo
               %estaremos usando en el siguiente paso
               direction = direction*(360/(2*pi));
               for oy = -w:w+1
                   for ox = -w:w+1
                       %Absolute x and y values of the point in the window
                       %being examined
                       x = cx + ox;
                       y = cy + oy;
                       
                       %If point falls outside of range just ignore it
                       if(x < 1 || x > octSize)
                           continue;
                       elseif(y < 1 || y >octSize)
                           continue;
                       end
                       [pointM,pointDir] = obj.obtainGradient(L,x,y);
                       weight = kernel(oy+w,ox+w)*pointM;
                       %Get the bin where the direction belongs
                       for k = 1:36
                          if(pointDir >(k-1)*10 && pointDir < k*10)
                             bin = k;
                             break;
                          end
                       end
                       hist(bin) = hist(bin)+weight;
                   end
               end
               [maxVal,maxIndex] = max(hist);
               %Add the new point with the new direction
               newKps = [newKps;[kp(1),kp(2),kp(3),obj.adjustParabola(hist,maxIndex,binSize)]];
               for k = 1:bins 
                  if(k == maxIndex)
                      continue;
                  end
                  
                  if(0.8*maxVal <= hist(k))
                     newKps = [newKps,[kp(1),kp(2),kp(3),obj.adjustParabola(hist,k,binSize)]]; 
                  end 
               end
            end
        end
        %Pendientes: Adjust parabola y obtainGradient
        
        
end
        
        
        
        
    
    
    
end
  