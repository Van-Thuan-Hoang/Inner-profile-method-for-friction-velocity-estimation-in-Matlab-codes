function [frictionVelocity, E1] = UtauEstimationProposed(y, U, K, a, nu, Utau0, deltaUtau, M1, M2)
            
            Ue = 0.99*max(U);
            nComparison = InnerIndex(Ue,y,U,Utau0,nu);
            indexInner = 1:nComparison;
            Utau = Utau0;   % inital guessed value of the friction velocit            
            yPlusExperiment = y * Utau/nu;     %y in wall units        
            UplusExperiment = (U / Utau)';       % mean velocity in wall unit 
            
            Uplus0 = InnerProfile(yPlusExperiment(indexInner),K,a,M1,M2);              
            residual1 = 1/nComparison *sum( abs(Uplus0 - UplusExperiment(indexInner))./abs(Uplus0) );
                        
            index = 1;           
            Utau = Utau - deltaUtau;   
            nComparison = InnerIndex(Ue,y,U,Utau,nu);
            indexInner = 1:nComparison;
            yPlusExperiment = y * Utau/nu;          %y in wall units
            UplusExperiment = (U / Utau)';
            
            Uplus0 = InnerProfile(yPlusExperiment(indexInner),K,a,M1,M2);              
            residual = 1/nComparison *sum( abs(Uplus0 - UplusExperiment(indexInner))./abs(Uplus0) );
    
            % The sign of delta uTau
            signDeltaUtau = -1;
            if (residual > residual1), signDeltaUtau = 1;  
            end
            
            residual0 = 1000000;
            residual = residual0 - 0.1; 
            indexMax = floor(Utau0/deltaUtau) + 1;
            %%{
            while (Utau >0 && index<indexMax && residual < residual0)  
                Utau = Utau + signDeltaUtau * deltaUtau;
                nComparison = InnerIndex(Ue,y,U,Utau,nu);
                indexInner = 1:nComparison;
                yPlusExperiment = y * Utau/nu;           %y in wall units        
                UplusExperiment = (U / Utau)';       % mean velocity in wall unit
                
                Uplus0 = InnerProfile(yPlusExperiment(indexInner),K,a,M1,M2);              
                residual0 = residual;
                residual = 1/nComparison *sum( abs(Uplus0 - UplusExperiment(indexInner))./abs(Uplus0) );
 
                index = index + 1;
                
                %semilogx(yPlusExperiment(indexInner), UplusExperiment(indexInner),'--'); hold on;
            end
            Utau = Utau - signDeltaUtau * deltaUtau; 
            residual = residual0;
            %}            
            
            %----------------
            frictionVelocity = Utau;
            E1 = abs(residual);
end
