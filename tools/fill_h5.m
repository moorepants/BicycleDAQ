function fill_h5(directories, all)
% function fill_h5(directories, all)
% Saves all mat files in the data and CalibData directories as hdf5 files.
%
% Parameters
% ----------
% directories : cell array
%   Should contain '../data', '../data/CalibData' or both.
% all : 0 or 1
%   0 if you only want the lastest mat files to be converted, and 1 if you
%   want all the mat files to be converted.

for j = 1:length(directories)
    pathToH5 = [directories{j} filesep 'h5'];
    display(sprintf('Checking %s', pathToH5))

    % get the details of the h5 directory
    h5info = dir(pathToH5);

    % get the number of the last file in the h5 directory
    lasth5 = str2num(h5info(end).name(1:end - 3));
    numH5Files = length(h5info) - 2;

    % if all of the sequential files are not there then convert all files
    if lasth5 ~= numH5Files - 1
        display('You are missing some h5 files, computing all of them.')
        all = 1
    end

    % if there are no files in the h5 directory
    if isempty(lasth5)
        lasth5 = -1;
    end
    display(sprintf('The last h5 file is %d', lasth5))

    % find out which mat files are in the directory
    display(sprintf('Checking %s', directories{j}))
    dirinfo = what(directories{j});
    matfiles = sort(dirinfo.mat);
    lastmat = matfiles{end};
    lastmat = str2num(lastmat(1:end - 4))

    if all == 0
        % the +2 is because of the . and .. in h5info.names
        matfiles = matfiles(lasth5 + 2:lastmat + 1);
    end

    matfiles

    for i = 1:length(matfiles)
        filename = matfiles{i};
        display(sprintf('Saving: %s', [directories{j} filesep matfiles{i}]))
        hdf5_save(directories{j}, filename(1:end - 4));
        if j == 1
            clear global InputPairs NIData VNavCols VNavData VNavDataText par
        else
            clear global data
        end
    end
end

function hdf5_save(directory, runid)
addpath('hdf5matlab')

load([directory filesep runid '.mat'])

if strcmp(directory, ['..' filesep 'data'])
    hdf5save([directory filesep 'h5' filesep runid '.h5'], ...
             'InputPairs', 'InputPairs', ...
             'NIData', 'NIData', ...
             'VNavCols', 'VNavCols', ...
             'VNavData', 'VNavData', ...
             'VNavDataText', 'VNavDataText', ...
             'par', 'par')
elseif strcmp(directory, ['..' filesep 'data' filesep 'CalibData'])
    hdf5save([directory filesep 'h5' filesep runid '.h5'], ...
             'data', 'data')
end
