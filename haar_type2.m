function mlist = haar_type2(m_max, E)    
    mlist = [];
    for m = 1:m_max
        mlist{m} = [];       
        for i = 1:2^m
            for j = 1:2^m
                new_phi = reshape(kron(E{m}{i,j},ones(32/2^m)),1024,1);
                new_phi = new_phi / norm(new_phi);
                mlist{m} = [mlist{m}, new_phi];
            end
        end
    end    
end