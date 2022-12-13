function [Uplus, B] = InnerProfile(yPlus, K, a, M1, M2)

[Uplus0, B] = MuskerProfile(yPlus, K, a);
Uplus0 = Uplus0 + BumpUplus(yPlus, M1,M2); 

Uplus = Uplus0;

end

function [MuskerUplus, B] = MuskerProfile(yPlus, K, a)

alpha = (-1/K - a)/2;
beta = sqrt(-2*a*alpha - alpha^2);
R = sqrt(alpha^2 + beta^2);

indexB = 1;
maxIndex = length(yPlus);
yPlusB = 100;
while indexB<maxIndex && yPlus(indexB)<yPlusB
    indexB = indexB + 1;
end
if yPlus(indexB)<yPlusB
    yPlus = [yPlus;  yPlusB];
    indexB = maxIndex + 1;
end

muskerUplus = 1/K*log( (yPlus-a)/(-a) ) ...
              + R^2/a/(4*alpha - a) ...
              *( ...
              (4*alpha + a) * log( -a/R*( (yPlus-alpha).^2+beta^2 ).^0.5 ./ (yPlus-a) ) ...
              + alpha/beta * (4*alpha + 5*a) * ( atan( (yPlus-alpha)/beta ) + atan(alpha/beta) ) ...
              );

%------------
MuskerUplus = muskerUplus(1:maxIndex);
B = muskerUplus(indexB) - 1/K*log(yPlus(indexB));
end

function BumpUplus = BumpUplus(yPlus,M1,M2)

%M1 = 30; M2 = 2.85;
BumpUplus = exp( -(log(yPlus./M1)).^2 )./M2;

end




































