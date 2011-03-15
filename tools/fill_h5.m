function fill_h5(directory)

dirinfo = what(directory);
matfiles = dirinfo.mat;
for i=1:length(matfiles)
    filename = matfiles{i};
    display(sprintf('Saving: %s', matfiles{i}))
    hdf5_save_test(filename(1:end-4));
    clear InputPairs NIData VNavCols VNavData VNavDataText par
end
