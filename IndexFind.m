
function indexFind = IndexFind(y,y0)

    maxIndex = length(y);
    index = 1;
    while index <= maxIndex && y(index)<y0
        index = index + 1;
    end
    %-----------------------------
    indexFind = index;
end
