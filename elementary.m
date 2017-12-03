function mlist = elementary(m_max)
mlist = [];
for m = 1:m_max
    mlist{m} = [];       
    for i = 1:2^m
        for j = 1:2^m
            mlist{m}{i,j} = zeros(2^m);
            mlist{m}{i,j}(i,j) = 1;
        end
    end
end    
end