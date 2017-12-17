filename = 'hw9_prob_a1.txt';
[raw1,delimiterOut1] = importdata(filename);

filename = 'hw9_prob_a2.txt';
[raw2,delimiterOut2] = importdata(filename);

filename = 'hw9_prob_a3.txt';
[raw3,delimiterOut3] = importdata(filename);

filename = 'hw9_prob_a4.txt';
[raw4,delimiterOut4] = importdata(filename);

%define transition matrices for action/direction 1,2,3 and 4
transition1 = zeros(81,81);
transition2 = zeros(81,81);
transition3 = zeros(81,81);
transition4 = zeros(81,81);

row = size(raw1,1);

for i = 1:row
    transition1(raw1(i,1),raw1(i,2)) = raw1(i,3);
    transition2(raw2(i,1),raw2(i,2)) = raw2(i,3);
    transition3(raw3(i,1),raw3(i,2)) = raw3(i,3);
    transition4(raw4(i,1),raw4(i,2)) = raw4(i,3);
end

%load rewards array
fileID = fopen('hw9_rewards.txt','r');
formatSpec = '%d';
sizeFormat = [1 Inf];
rewards = fscanf(fileID,formatSpec,sizeFormat);
rewards = rewards';
fclose(fileID);

actionValue = zeros(81,4);
actionTaken = ones(81,1);
probMtx = zeros(81,81);
discount = 0.9925;

%converge in 5 iterations
for iteration = 1:5

    %compute transition probability matrix by updated actions taken
    for row = 1:81
        for col = 1:81
            
            if actionTaken(row) == 1
                currEntry = -discount * transition1(row,col);
            elseif actionTaken(row) == 2
                currEntry = -discount * transition2(row,col);
            elseif actionTaken(row) == 3
                currEntry = -discount * transition3(row,col);
            else
                currEntry = -discount * transition4(row,col);
            end
            
            if row == col
                currEntry = 1 + currEntry;
            end
            
            probMtx(row,col) = currEntry;
            
        end
    end

    %compute state value functions, stateValue
    stateValue = probMtx \ rewards;
    
    %compute action value functions, actionValue
    for row = 1:81
        currEntry1 = 0;
        currEntry2 = 0;
        currEntry3 = 0;
        currEntry4 = 0;
        
        for state = 1:81
            currEntry1 = currEntry1 + transition1(row,state) * stateValue(state);
            currEntry2 = currEntry2 + transition2(row,state) * stateValue(state);
            currEntry3 = currEntry3 + transition3(row,state) * stateValue(state);
            currEntry4 = currEntry4 + transition4(row,state) * stateValue(state);
        end
        
        actionValue(row,1) = currEntry1;
        actionValue(row,2) = currEntry2;
        actionValue(row,3) = currEntry3;
        actionValue(row,4) = currEntry4;
    end
    
    %derive greedy policy:update actionTaken by 1,2,3 or 4 with max actionValue
    [maxValue,maxIndex] = max(actionValue,[],2);
    
    for step = 1:81
        actionTaken(step) = maxIndex(step);
    end
end

%print out stateValue and actionTaken in the maze format
mazeState = zeros(9,9);
mazeAction = zeros(9,9);
for row = 1:9
    mazeState(row,:)= stateValue(((row - 1) * 9 + 1):(row * 9));
    mazeAction(row,:)= actionTaken(((row - 1) * 9 + 1):(row * 9));
end
mazeState = mazeState';
mazeAction = mazeAction';

disp("job done");