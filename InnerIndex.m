function indexInner = InnerIndex(Ue,y,U,Utau,nu)

delta = TBLthickness(y,U,Ue);

ReTau = delta*Utau/nu;
yPlusInner = 2.6*sqrt(ReTau);
yPlus = y*Utau/nu;
indexInner = IndexFind(yPlus,yPlusInner);

end