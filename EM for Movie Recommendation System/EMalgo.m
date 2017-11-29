fileID = fopen('hw8_ratings.txt','r');
formatSpec = '%s';
sizeInitial = [50 Inf];
rating = fscanf(fileID,formatSpec,sizeInitial);
rating = rating';
fclose(fileID);

fileID = fopen('hw8_probRgivenZ_init.txt','r');
formatSpec = '%f';
sizeInitial = [4 Inf];
condiProb = fscanf(fileID,formatSpec,sizeInitial);
condiProb = condiProb';
fclose(fileID);

fileID = fopen('hw8_probZ_init.txt','r');
formatSpec = '%f';
sizeInitial = [1 Inf];
typeProb = fscanf(fileID,formatSpec,sizeInitial);
typeProb = typeProb';
fclose(fileID);

%compute loglikelihood of data at 0 iteration
totalLogDataProb = 0;
ePosteriorNumerator = zeros(4,279);
ePosteriorDenominator = zeros(279,1);
for student = 1:279
    studentDataProb = 0;
    
    for type = 1:4
        product = 1;
        
        for movie = 1:50
            if rating(student,movie) == '1'
                product = product * condiProb(movie,type);
            end
            
            if rating(student,movie) == '0'
                product = product * (1 - condiProb(movie,type));
            end
        end
        
        studentDataProb = studentDataProb + typeProb(type) * product;
        ePosteriorNumerator(type,student) = typeProb(type) * product;
    end
    
    ePosteriorDenominator(student) = studentDataProb;
    logStudentDataProb = log(studentDataProb);
    totalLogDataProb = totalLogDataProb + logStudentDataProb;
end

%print loglikelihood at 0 iteration
loglikely = totalLogDataProb / 279;
disp(loglikely);

%compute posteriors for each student at 0 iteration
ePosterior = zeros(4,279);
for student = 1:279
    for type = 1:4
        ePosterior(type,student) = ePosteriorNumerator(type,student) / ePosteriorDenominator(student);
    end
end

%Run a total of 64 iterations
for iteration = 1:64
    
    %update condiProb Matrix and typeProb Array
    for type = 1:4
        
        % update P(Rj=movie|Z=type), belongs to condiProb Matrix
        for movie = 1:50
            denominator = 0;
            numerator = 0;
        
            for student = 1:279
                denominator = denominator + ePosterior(type,student);
            
                if rating(student,movie) == '1'
                    numerator = numerator + ePosterior(type,student);
                end
                
                if rating(student,movie) == '?'
                    numerator = numerator + ePosterior(type,student) * condiProb(movie,type);
                end
            end
        
            condiProb(movie,type) = numerator / denominator;
        end
        
        %update P(Z=type), belongs to typeProb Array
        sum = 0;
        for student = 1:279
            sum = sum + ePosterior(type,student);
        end
        typeProb(type) = sum / 279;
    end
    
    %update loglikelyhood of data
    totalLogDataProb = 0;
    for student = 1:279
        studentDataProb = 0;
        
        for type = 1:4
            product = 1;
            
            for movie = 1:50
                if rating(student,movie) == '1'
                    product = product * condiProb(movie,type);
                end
            
                if rating(student,movie) == '0'
                    product = product * (1 - condiProb(movie,type));
                end
            end
            
            studentDataProb = studentDataProb + typeProb(type) * product;
            ePosteriorNumerator(type,student) = typeProb(type) * product;
        end
        
        ePosteriorDenominator(student) = studentDataProb;
        logStudentDataProb = log(studentDataProb);
        totalLogDataProb = totalLogDataProb + logStudentDataProb;
    end
    
    %print loglikelihood of data at 1,2,4,8,16,32,64 iteration
    loglikely = totalLogDataProb / 279;
    if iteration == 1
        disp(loglikely);
    end
    if iteration == 2
        disp(loglikely);
    end
    if iteration == 4
        disp(loglikely);
    end
    if iteration == 8
        disp(loglikely);
    end
    if iteration == 16
        disp(loglikely);
    end
    if iteration == 32
        disp(loglikely);
    end
    if iteration == 64
        disp(loglikely);
    end
    
    %update posterior probability for each student,ePosterior Matrix
    for student = 1:279
        for type = 1:4
            ePosterior(type,student) = ePosteriorNumerator(type,student) / ePosteriorDenominator(student);
        end
    end
end

%compute my expected ratings on the movies I havent yet seen
myExRate = zeros(50,1);
myExRate = myExRate - 1;
myrow = 56;
for movie = 1:50
    if rating(myrow,movie) == '?'
        sum = 0;
        for type = 1:4
            sum = sum + ePosterior(type,myrow) * condiProb(movie,type);
        end
        myExRate(movie) = sum;
    end
end

fid = fopen('hw8_movieTitles.txt');
line_ex = fgetl(fid);
movieName = strings(0);
while ischar(line_ex)
    movieName = cat(1,movieName,line_ex);
    line_ex = fgetl(fid);
end

tuple = {};
for movie = 1:50
    tuple{1,movie} = movieName(movie);
    tuple{2,movie} = myExRate(movie);
end
tuple = tuple';
sorted = sortrows(tuple, 2);

for movie = 1:50
    if sorted{movie,2} ~= -1
        disp(sorted{movie,1});
    end
end