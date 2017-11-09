fileID = fopen('hw4_nasdaq00.txt','r');
formatSpec = '%f';
sizeA = [1 Inf];
A = fscanf(fileID,formatSpec,sizeA);
[m,n] = size(A);
Base = zeros(3,3);
other = [0 0 0];
for t = 4:n
    X1 = A(t-1);
    X2 = A(t-2);
    X3 = A(t-3);
    C = [X1 X2 X3];
    D = C'* C;
    E = C * A(t);
    Base = Base + D;
    other = other + E;
end
W = inv(Base) * other'
