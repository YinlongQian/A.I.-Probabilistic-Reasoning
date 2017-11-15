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

fileID3 = fopen('hw5_test3.txt','r');
formatSpec = '%d';
size = [64 Inf];
test3 = fscanf(fileID3,formatSpec,size);
fclose(fileID3);

fileID4 = fopen('hw5_test5.txt','r');
formatSpec = '%d';
size = [64 Inf];
test5 = fscanf(fileID4,formatSpec,size);
fclose(fileID4);


w = [
-1.3637
-1.4414
-2.0814
-0.9597
-1.7514
-0.485
0.8857
1.9567
0.8428
0.0206
0.9162
-0.6138
-0.1233
0.5922
-1.5064
0.0034
2.84
1.1854
1.0412
0.3395
0.2824
-2.1745
-3.1405
-3.6695
2.2742
0.7275
1.6632
-0.5657
-1.5898
-0.5549
0.4115
-0.238
0.2042
0.2624
0.2318
-0.928
-0.1605
-0.1029
-0.7062
-0.1677
1.2957
-0.9795
0.5357
0.6847
0.4476
-0.7437
0.0308
-1.8091
0.5052
-0.2876
1.0806
0.8777
-0.0174
-0.2429
0.5469
-1.6282
0.3255
0.3474
-0.3624
4.5096
0.4771
0.4901
0.0107
-0.6354];

errornum = 0;
for index = 1:700
    prob = posSigmoid(w,data3(:,index));
    
    if(prob > 0.5)
        errornum = errornum + 1;
    end
end

for index = 1:700
    prob = posSigmoid(w,data5(:,index));
    
    if(prob < 0.5)
        errornum = errornum + 1;
    end
end

errornum
percentError = errornum/1400

errornum = 0;
for index = 1:400
    prob = posSigmoid(w,test3(:,index));
    
    if(prob > 0.5)
        errornum = errornum + 1;
    end
end

for index = 1:400
    prob = posSigmoid(w,test5(:,index));
    
    if(prob < 0.5)
        errornum = errornum + 1;
    end
end

errornum
percentError = errornum/800


function posValue = posSigmoid(w,sample)
posValue = 1 / (1 + exp(-dot(w,sample)));
end

function negValue = negSigmoid(w,sample)
negValue = 1 / (1 + exp(dot(w,sample)));
end