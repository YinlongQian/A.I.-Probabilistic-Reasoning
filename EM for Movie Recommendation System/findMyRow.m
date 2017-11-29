fid = fopen('hw8_studentPIDs.txt');
line_ex = fgetl(fid);
count = 1;
while ischar(line_ex)
    if strcmp(line_ex,"A92~~~~~~")
        disp(count);
    end
    line_ex = fgetl(fid);
    count = count + 1;
end