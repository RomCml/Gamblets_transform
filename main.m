%we choose the measurement functions phi to be haar wavelets
m_max = 5;
E = elementary(m_max - 1);
phitype2 = haar_type2(m_max - 1, E);
phi = haar(m_max, E, phitype2);

%C can be any covariance matrix
load('covariance_matrix.mat') 
%this is the covariance matrix of the MNIST database

theta = [];
psi = [];
W = [];
chi = [];
A = [];
B = [];
N = [];
phichi = [];
for m = 1 : m_max
    theta{m} = phi{m}' * C * phi{m};
    psi{m} = C * phi{m} * theta{m}'^(-1);
    W{m} = [zeros(3*4^(m-1),4^(m-1)),eye(3*4^(m-1))];
    chi{m} = psi{m} * W{m}';
    A{m} = psi{m}' * C^(-1) * psi{m};
    B{m} = chi{m}' * C^(-1) * chi{m};
    N{m} = A{m} * W{m}' * B{m}^(-1);
    phichi{m} = phi{m} * N{m};
end


%I can be any 32 x 32 image, reshaped as a column vector with 1024 elements 
load('4digit.mat') %this is a '4' digit from the MNIST database

%decomposition of the image in the wavelets basis
coef = [];
coef2 = [];
for m = 2 : m_max
    coef{m} = phichi{m}' * I;
end
coef2 = phi{1}' * I;
Iid = zeros(1024,1);
for m = 2 : m_max
    for j = 1 : 3*4^(m-1)
        Iid = Iid + coef{m}(j) * chi{m}(:,j);
    end
end
for j=1:4
    Iid = Iid + coef2(j)*psi{1}(:,j);
end

%Icomp is the reconstructed I
%one can check that here, without any compression, I = Icomp
norm(I - Iid)

%compression:
t = 0.5; %threshold 
c = 0; %quantifying the compression
for m = 2 : m_max
    for i = 1 : size(coef{m}, 1)
        if abs(coef{m}(i)) < t
            coef{m}(i) = 0;
            c = c + 1;
        end
    end
end
for i = 1 : size(coef2, 1)
    if abs(coef2(i)) < t
        coef2(i) = 0;
        c = c + 1;             
    end
end
compressionrate = c / 1024

Icomp = zeros(1024,1);
for m = 2 : m_max
    for j = 1 : 3*4^(m-1)
        Icomp = Icomp + coef{m}(j) * chi{m}(:,j);
    end
end
for j=1:4
    Icomp = Icomp + coef2(j)*psi{1}(:,j);
end

%L2 distance of the compression
L2distance = norm(I - Icomp) / norm(I)

%showing the new image
imshow(reshape(Icomp,32,32))