function fill_h5(directory)
% find out what files are in h5 directory
h5info = dir([directory filesep 'h5']);
h5names = cell(length(h5info), 1);
lasth5 = str2num(h5info(end).names)
bad = [];
j = 1;
for i = 1:length(h5info)
    if strcmp(h5info(i).name, '.') || strcmp(h5info(i).name, '..')
        bad(j) = i;
        j = j + 1;
    else
        h5names{i} = h5info(i).name(1:end-3);
    end
end
% remove the . and ..
h5names(bad) = [];
% sort
h5names = sort(h5names);

dirinfo = what(directory);
matfiles = dirinfo.mat;
lastmat = str2num(matfiles{end})
matnames = cell(length(matfiles), 1);
for i = 1:length(matnames)
    fname = matfiles{i};
    matnames{i} = fname(1:end-4);
end
matnames = sort(matnames);

if all == 0
    matfiles = matfiles{lasth5:lastmat)
end
    
% for i=1:length(matfiles)
%     filename = matfiles{i};
%     display(sprintf('Saving: %s', matfiles{i}))
%     hdf5_save_test(filename(1:end-4));
%     clear InputPairs NIData VNavCols VNavData VNavDataText par
% end
