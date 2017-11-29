fileID = fopen('hw8_ratings.txt','r');
formatSpec = '%s';
sizeInitial = [50 Inf];
rating = fscanf(fileID,formatSpec,sizeInitial);
rating = rating';
fclose(fileID);

movieSaw = zeros(50,1);
movieRecom = zeros(50,1);
for eachstudent = 1:279
    for eachmovie = 1:50
        if rating(eachstudent, eachmovie) ~= '?'
            movieSaw(eachmovie) = movieSaw(eachmovie) + 1;
        end
        
        if rating(eachstudent, eachmovie) == '1'
            movieRecom(eachmovie) = movieRecom(eachmovie) + 1;
        end
    end
end

movieRatio = zeros(50,1);
for i = 1:50
    movieRatio(i) = movieRecom(i) / movieSaw(i);
end

indices = (1:1:50);
indices = indices';
for i = 49:-1:1
    for j = 1:i
        if movieRatio(j) > movieRatio(j+1)
            temp = movieRatio(j);
            movieRatio(j) = movieRatio(j+1);
            movieRatio(j+1) = temp;
            temp = indices(j);
            indices(j) = indices(j+1);
            indices(j+1) = temp;
        end
    end
end

fid = fopen('hw8_movieTitles.txt');
line_ex = fgetl(fid);
movieName = strings(0);
while ischar(line_ex)
    movieName = cat(1,movieName,line_ex);
    line_ex = fgetl(fid);
end

for i = 1:50
    disp(movieName(indices(i)));
end