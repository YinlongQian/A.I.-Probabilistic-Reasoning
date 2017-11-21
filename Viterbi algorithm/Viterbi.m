fileID = fopen('hw7_initialStateDistribution.txt','r');
formatSpec = '%f';
sizeInitial = [1 Inf];
initial = fscanf(fileID,formatSpec,sizeInitial);
initial = initial';
fclose(fileID);

fileID = fopen('hw7_emissionMatrix.txt','r');
formatSpec = '%f';
sizeEmission = [2 Inf];
emission = fscanf(fileID,formatSpec,sizeEmission);
emission = emission';
fclose(fileID);

fileID = fopen('hw7_transitionMatrix.txt','r');
formatSpec = '%f';
sizeTransition = [27 Inf];
transition = fscanf(fileID,formatSpec,sizeTransition);
transition = transition';
fclose(fileID);

fileID = fopen('hw7_observations.txt','r');
formatSpec = '%f';
sizeObservation = [1 Inf];
observation = fscanf(fileID,formatSpec,sizeObservation);
observation = observation';
fclose(fileID);

dynamicArr = zeros(27,240000);
backtrack = zeros(27,240000);

for i = 1:27
    if observation(1) == 0
        dynamicArr(i,1) = log(initial(i)) + log(emission(i,1));
    else
        dynamicArr(i,1) = log(initial(i)) + log(emission(i,2));
    end
end

for t = 2:240000
    for j = 1:27
        maxi = 1;
        maxValue = dynamicArr(1,(t-1)) + log(transition(1,j));
        
        for i = 1:27
            if(dynamicArr(i,(t-1)) + log(transition(i,j)) > maxValue)
                maxi = i;
                maxValue = dynamicArr(i,(t-1)) + log(transition(i,j));
            end
        end
        
        if observation(t) == 0
            dynamicArr(j,t) = maxValue + log(emission(j,1));
        else
            dynamicArr(j,t) = maxValue + log(emission(j,2));
        end
        
        backtrack(j,t) = maxi;
    end
end

hiddenStates = zeros(240000,1);

lastState = 1;
maxValue = dynamicArr(1,240000);
for i = 1:27
    if dynamicArr(i,240000) > maxValue
        lastState = i;
        maxValue = dynamicArr(i,240000);
    end
end

hiddenStates(240000) = lastState;

for t = 240000:-1:2
    nextState = hiddenStates(t);
    hiddenStates(t-1) = backtrack(nextState,t);
end

currLetter = 0;
for t = 1:240000
    if hiddenStates(t) ~= currLetter
        currLetter = hiddenStates(t);
        
        if currLetter == 27
            disp(' ');
        else
            disp(char(currLetter + 96));
        end
    end
end

plot(hiddenStates);

disp('job done');