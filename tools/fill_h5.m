function fill_h5(directory, all)
%Parameters
%----------
%directory : string
%   ../data
%all : 0 or 1
%   0 if you only want the lastest mat files to be converted, and 1 if you
%   want all the mat files to be converted.

% find out what files are in h5 directory
h5info = dir([directory filesep 'h5']);
lasth5 = str2num(h5info(end).name(1:end-3))

dirinfo = what(directory);
matfiles = dirinfo.mat;
lastmat = matfiles{end};
lastmat = str2num(lastmat(1:end-4))

if all == 0
    % the +2 is because of the . and .. in h5info.names
    matfiles = matfiles(lasth5+2:lastmat+1);
end
matfiles    
for i=1:length(matfiles)
    filename = matfiles{i};
    display(sprintf('Saving: %s', matfiles{i}))
    hdf5_save(filename(1:end-4));
    clear InputPairs NIData VNavCols VNavData VNavDataText par
end