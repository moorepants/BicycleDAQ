function fill_h5(directory)

dirinfo = what(directory);
matfiles = dirinfo.mat;
for i=1:length(matfiles)
    filename = matfiles{i};
    hdf5_save_test(filename(1:end-4));
end

function hdf5_save_test(runid)
addpath('hdf5matlab')

todata = ['..' filesep 'data'];

load([todata filesep runid '.mat'])

hdf5save([todata filesep 'h5' filesep runid '.h5'], ...
         'InputPairs', 'InputPairs', ...
         'NIData', 'NIData', ...
         'VNavCols', 'VNavCols', ...
         'VNavData', 'VNavData', ...
         'VNavDataText', 'VNavDataText', ...
         'par', 'par')
