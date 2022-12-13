%% Author: Van Thuan Hoang - Nov 2022
% Subjest:
% Reference: 
% Instruction: 
% fomular
%%
clc;
clear;
%close all;
fontSize = 14; lineWidth = 1.5; 
%--------------------------------------------------------------------------
load('Input_Data.mat');

%Kstr = '_Kfixed'; aStr = '_aFixed'; deltaYstr = '';
%Kstr = ''; aStr = ''; deltaYstr = '_deltaYfixed';
Kstr = ''; aStr = '_aFixed'; deltaYstr = '_deltaYfixed';

%% Estimate friction velocity for smooth surface cases

    % Optimize von Karman contant
    %minK = 0.2; maxK = 0.6; deltaK = 0.01;
    minK = 0.375; maxK = 0.385; deltaK = 0.001; 
    
    % Optimize aditive coefficient, a
    minA = -10.5; maxA = -10; deltaA =   0.01;  
    
    % Optimize deltaY: Accuracy of the closest measured location to the surface
    deltaYmin = -0.05e-3; deltaYmax = 0.15e-3; deltaYDelta = 0.01e-3;

    Utau = 1.5; deltaUtau = 1e-5;
    
    Karray = minK:deltaK:maxK;    
    aArray = minA:deltaA:maxA;    
    deltaYarray = deltaYmin:deltaYDelta:deltaYmax;
    
    if strcmp(Kstr,'_Kfixed'), Karray = [0.384]; end    
    if strcmp(aStr,'_aFixed'), aArray = [-10.3061]; end
    if strcmp(deltaYstr,'_deltaYfixed'),  deltaYarray = [0];   end         
    
    [Utau, Ksave, aSave, deltaYsave] = InnerProfileMethod(y,  U, nu, ...
        Karray, aArray, deltaYarray, Utau, deltaUtau);

%%
M1 = 30;
M2 = 2.85;

y = y + deltaYsave;

yPlusExperiment = y * Utau/nu;     %y in wall units        
UplusExperiment = (U / Utau)';      % mean velocity in wall unit 

Ue = 0.99*max(U);
[delta, indexDelta] = TBLthickness(y,U,Ue);
indexInner = InnerIndex(Ue,y,U,Utau,nu);
indexComparison = 1:indexInner;
[Uplus, Bsave] = InnerProfile(yPlusExperiment(indexComparison),Ksave,aSave,M1,M2); 
nComparison = length(indexComparison);            
Emin_whole = 1/nComparison *sum( abs(Uplus - UplusExperiment(indexComparison))./abs(Uplus) )*100;

maxX = 15; linearX = 1:1:maxX;
logX = 5:5:yPlusExperiment(indexDelta);
logY = 1/Ksave*log(logX)+Bsave;

Cf = 2*(Utau/Ue)^2;

%sdfdf
%}
%% Plot the result of the fitting method
%%{
figure('Position',[500 200 700 550]); 
semilogx(yPlusExperiment, UplusExperiment,'ok'); hold on;
set(gca,'fontsize',fontSize);
txt = ['\bullet\leftarrow u_{\tau} = ' num2str(Utau) ' m/s'];
text(yPlusExperiment(7),UplusExperiment(7),txt,'FontSize',fontSize);  

semilogx(yPlusExperiment(indexComparison), Uplus,'-+m','LineWidth',lineWidth); hold on;
semilogx(linearX,linearX,'--k','LineWidth',lineWidth*0.8); hold on;
semilogx(logX,logY,'--b','LineWidth',lineWidth*0.8);  grid on;  

%xlim([0.1 1e3]); %ylim([-5 30]);
xlabel('y^{+}','FontWeight','bold'); ylabel('U^{+}','FontWeight','bold');

title({'Velocity profile', ...
        ['\DeltaE_{fitting} = ' num2str(Emin_whole,'%.2f') ' %, C_{f} =' ...
       num2str(Cf,'%.6f') ', K = ' num2str(Ksave) ', a = ' num2str(aSave,'%.2f') ...
       ', B = ' num2str(Bsave) ]});
   
legend({'Experimental data by Osterlund (1999)','Proposed profile','Linear profile','Log-law profile'},'location','southeast');            

%}












