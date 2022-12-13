function [delta, indexDelta] = TBLthickness(y,U,Ue)

maxIndex = length(U);
index = 1;
while index <= maxIndex && U(index)<Ue
    index = index + 1;
end
%-----------------------------
delta = interp1(U(index-1:index),y(index-1:index),Ue);
indexDelta = index-1;

end