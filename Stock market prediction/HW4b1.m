fileID = fopen('hw4_nasdaq00.txt','r');
formatSpec = '%f';
sizeA = [1 Inf];
A = fscanf(fileID,formatSpec,sizeA);
[m,n] = size(A);
lc = [0.9507 0.0156 0.0319];
Base = 0;

for t = 4:n
    X1 = A(t-1);
    X2 = A(t-2);
    X3 = A(t-3);
    C = [X1 X2 X3];
    predict = lc * C';
    Base = Base + (A(t) - predict)^2;
end

MSE2000 = Base / (n - 3)