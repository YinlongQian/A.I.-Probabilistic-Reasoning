fileID = fopen('hw5_train3.txt','r');
formatSpec = '%d';
size = [64 Inf];
data3 = fscanf(fileID,formatSpec,size);
fclose(fileID);

fileID2 = fopen('hw5_train5.txt','r');
formatSpec = '%d';
size = [64 Inf];
data5 = fscanf(fileID2,formatSpec,size);
fclose(fileID2);

rate = 0.2/1400;
w(1:64)=0;
w = w';
yaxis = zeros(1,17001);
yaxis(1) = -970.4061;
% lastlog = 1;

for num = 1:17000
    logDeriW = zeros([64 1]);
    for index = 1:700
        logDeriW = logDeriW + (0 - posSigmoid(w,data3(:,index))) * data3(:,index);
    end
    
    for index = 1:700
        logDeriW = logDeriW + (1 - posSigmoid(w,data5(:,index))) * data5(:,index);
    end
    
    w = w + rate * logDeriW;
    
    currlog = 0;
    for index = 1:700
        currlog = currlog + log(negSigmoid(w,data3(:,index)));
    end
    
    for index = 1:700
        currlog = currlog + log(posSigmoid(w,data5(:,index)));
    end
    
    yaxis(num + 1) = currlog;
    
    %{
    diff = abs(currlog - lastlog);
    currlog
    if(diff < 0.0001)
        num
        break
    end
    
    lastlog = currlog;
    %}
end

xaxis = 0:17000;
plot(xaxis,yaxis);


function posValue = posSigmoid(w,sample)
posValue = 1 / (1 + exp(-dot(w,sample)));
end

function negValue = negSigmoid(w,sample)
negValue = 1 / (1 + exp(dot(w,sample)));
end

%{
function HMtx = Hessian(posSig, negSig, sample)
HMtx = posSig * negSig * (sample * (sample'));
end
%}
