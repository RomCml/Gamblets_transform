function mlist = haar(m_max, E, phitype2)
    Q{1}=[3,-1;-1,-1];
    Q{2}=[-1,3;-1,-1];
    Q{3}=[-1,-1;3,-1];
    
    mlist = [];
    mlist{1}=[];
    for i=1:3
        new_phi = reshape(kron(Q{i},ones(32/2)),1024,1);
        new_phi = new_phi / norm(new_phi);
        mlist{1}=[mlist{1},new_phi];
    end
    type2 = reshape(ones(32),1024,1);
    type2 = type2 / norm(type2);
    mlist{1} = [type2, mlist{1}];
    for m = 2:m_max
        mlist{m} = [];
        for i=1:3
            O{m}{i}=kron(Q{i},ones(32/2^m));
        end
        for j=1:2^(m-1)
            for jj=1:2^(m-1)
                for i=1:3
                    new_phi = reshape(kron(E{m-1}{j,jj},O{m}{i}),1024,1);
                    new_phi = new_phi / norm(new_phi);
                    mlist{m}=[mlist{m}, new_phi];
                end
            end        
        end
        mlist{m}=[phitype2{m-1}, mlist{m}];
    end
end