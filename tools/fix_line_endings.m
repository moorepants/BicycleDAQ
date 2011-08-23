% remove the \r\n from the par fields from the vectornav runs 0-87
clear all;close all;clc;
dirinfo = what('..\data');
matfiles = dirinfo.mat;

for i=1:length(matfiles)
    pathnfile = ['..\data\' matfiles{i}];
    load(pathnfile)
    colnames = fieldnames(par);
    found = 0;
    for j=1:length(colnames)
        value = par.(colnames{j});
        try
            if ischar(value) && strcmp(value(1), '$')
                display('found it')
                display(['test' value 'test'])
                newvalue = sscanf(value, '%s\r\n');
                display(['test' newvalue 'test'])
                % set the par value to the new value with out the line
                % endings
                par.(colnames{j}) = newvalue;
                found = 1;
            end
        end
    end
    if found == 1
        display('Saved the file')
        save(pathnfile, 'NIData', 'VNavData', 'VNavDataText', 'par')
    end
end
