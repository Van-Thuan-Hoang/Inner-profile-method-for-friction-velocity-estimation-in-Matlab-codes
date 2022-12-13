function [UtauSave, Ksave, aSave, deltaYsave] = InnerProfileMethod( ...
    y0,  U, nuRef, Karray, aArray, deltaYarray, UtauSave0, deltaUtau)

%-------------------------------------------------
UtauSave = 0; Ksave = 0; aSave = 0; deltaYsave = 0;

maxArrayLengthK = 50; maxArrayLengthA = 50; maxArrayLengthDeltaY = 0; 
increseNumK = 5; increseNumA = 10; increseNumDeltaY = 20;

EK = 0; EA = 0;

maxIndexK = length(Karray);
maxIndexA = length(aArray);
maxIndexDeltaY = length(deltaYarray);

Emin = 1000000; Emin1 = 1; Emin2 = 1;
E = Emin + 1;
M1 = 30; M2 = 2.85;
%-----------------------------------------------
indexK = 1; EKarray = [];
while indexK<=maxIndexK  
    K = Karray(indexK);
    indexA = 1; EAarray = [];
while indexA <= maxIndexA   
    a = aArray(indexA); 
    indexDeltaY = 1;  EdeltaY = [];

while indexDeltaY <= maxIndexDeltaY
    deltaY = deltaYarray(indexDeltaY); 
    y = y0 + deltaY;
        
    [Utau, E] = UtauEstimationProposed(y, U, K, a, nuRef, UtauSave0, deltaUtau, M1, M2); 
    
    if E < Emin            
            Emin = E;            
            Ksave = K;
            aSave = a;
            deltaYsave = deltaY;
            UtauSave = Utau;            
    end 
    
    clc       
    [indexK indexA indexDeltaY Karray(1) aArray(1) deltaYarray(1)*1000 Emin1*100]
    [maxIndexK maxIndexA maxIndexDeltaY Karray(end) aArray(end) deltaYarray(end)*1000 Emin2*100]
    [UtauSave Ksave aSave  deltaYsave*1000 Emin*100] 
    
    %%{
    EdeltaY = [EdeltaY, E];
    if indexDeltaY == maxIndexDeltaY
        EA = min(EdeltaY);
        EdeltaY = [];
    end
    %}
    
% delatY loop
    if indexDeltaY == maxIndexDeltaY && maxIndexDeltaY > 1 && maxArrayLengthDeltaY > 0
        maxArrayLength = maxArrayLengthDeltaY;
        increseNum = increseNumDeltaY;
        if deltaYsave == deltaYarray(end)
            deltaDeltaY = deltaYarray(maxIndexDeltaY) - deltaYarray(maxIndexDeltaY-1);
            addDeltaY = (deltaYarray(end)+deltaDeltaY):deltaDeltaY:(deltaYarray(end)+increseNum*deltaDeltaY);
            deltaYarray = [deltaYarray, addDeltaY];            
            maxIndexDeltaY = maxIndexDeltaY + increseNum;
            if maxIndexDeltaY > maxArrayLength
                deltaIndex = maxIndexDeltaY - maxArrayLength;
                deltaYarray = deltaYarray(deltaIndex+1:end);
                maxIndexDeltaY = maxIndexDeltaY - deltaIndex;
                indexDeltaY = indexDeltaY -  deltaIndex;
            end
        elseif deltaYsave == deltaYarray(1)
            deltaDeltaY = deltaYarray(2) - deltaYarray(1);
            addDeltaY = (deltaYarray(1)-increseNum*deltaDeltaY):deltaDeltaY:(deltaYarray(1)-deltaDeltaY);
            deltaYarray = [addDeltaY,deltaYarray]; 
            deltaYarray = fliplr(deltaYarray);
            maxIndexDeltaY = maxIndexDeltaY + increseNum;
            if maxIndexDeltaY > maxArrayLength
                deltaIndex = maxIndexDeltaY - maxArrayLength;
                deltaYarray = deltaYarray(deltaIndex+1:end);
                maxIndexDeltaY = maxIndexDeltaY - deltaIndex;
                indexDeltaY = indexDeltaY -  deltaIndex;
            end
        end
        
    end    
    indexDeltaY = indexDeltaY + 1; 
end

% B loop
    EAarray = [EAarray, EA];
    if indexA == maxIndexA
        EK = min(EAarray);
        EAarray = [];
    end
    
    if indexA == maxIndexA && maxIndexA > 1 && maxArrayLengthA > 0
        maxArrayLength = maxArrayLengthA;
        increseNum = increseNumA;
        if aSave == aArray(end)            
            aDelta = aArray(maxIndexA) - aArray(maxIndexA-1);
            addA = (aArray(maxIndexA)+aDelta):aDelta:(aArray(maxIndexA)+increseNum*aDelta);
            aArray = [aArray, addA];            
            maxIndexA = maxIndexA + increseNum;
            if maxIndexA > maxArrayLength
                deltaIndex = maxIndexA - maxArrayLength;
                aArray = aArray(deltaIndex+1:end);
                maxIndexA = maxIndexA - deltaIndex;
                indexA = indexA -  deltaIndex;
            end
        elseif aSave == aArray(1)
            aDelta = aArray(2) - aArray(1);
            addA = (aArray(1)-increseNum*aDelta):aDelta:(aArray(1)-aDelta);
            aArray = [addA, aArray]; 
            aArray = fliplr(aArray);
            maxIndexA = maxIndexA + increseNum;
            if maxIndexA > maxArrayLength
                deltaIndex = maxIndexA - maxArrayLength;
                aArray = aArray(deltaIndex+1:end);
                maxIndexA = maxIndexA - deltaIndex;
                indexA = indexA -  deltaIndex;
            end
        end
    end
    indexA = indexA + 1;
    
end 
% K loop
    EKarray = [EKarray, EK];
    
    if indexK == maxIndexK && maxIndexK > 1 && maxArrayLengthK > 0        
        maxArrayLength = maxArrayLengthK;
        increseNum = increseNumK;
        if Ksave == Karray(end)            
            Kdelta = Karray(maxIndexK) - Karray(maxIndexK-1);
            addK = (Karray(maxIndexK)+Kdelta):Kdelta:(Karray(maxIndexK)+increseNum*Kdelta);
            Karray = [Karray, addK];            
            maxIndexK = maxIndexK + increseNum;
            if maxIndexK > maxArrayLength
                deltaIndex = maxIndexK - maxArrayLength;
                Karray = Karray(deltaIndex+1:end);                
                EKarray = EKarray(deltaIndex+1:end);
                maxIndexK = maxIndexK - deltaIndex;
                indexK = indexK -  deltaIndex;
            end
        elseif Ksave == Karray(1)
            Kdelta = Karray(2) - Karray(1);
            addK = (Karray(1)-increseNum*Kdelta):Kdelta:(Karray(1)-Kdelta);
            Karray = [addK, Karray]; 
            Karray = fliplr(Karray);
            EKarray = fliplr(EKarray);
            maxIndexK = maxIndexK + increseNum;
            if maxIndexK > maxArrayLength
                deltaIndex = maxIndexK - maxArrayLength;
                Karray = Karray(deltaIndex+1:end);
                EKarray = EKarray(deltaIndex+1:end);
                maxIndexK = maxIndexK - deltaIndex;
                indexK = indexK -  deltaIndex;
            end         
        end 
    elseif EK > 1.2*Emin
        indexK = maxIndexK - 1;
    end
    
    indexK = indexK + 1;
    
    %if mod(indexK,5) == 1
        figure(200); cla reset; plot(Karray(1:indexK-1),EKarray*100,'-+b'); hold on; grid on;
        xlabel('K'); ylabel('\DeltaE_{fitting} [%]');
        title(['Fitting errer at K = ' num2str(Karray(indexK-1)) ', optimal K = ' num2str(Ksave) ]);
        pause(0.1);
    %end
end



end






