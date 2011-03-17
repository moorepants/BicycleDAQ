function vnav_text_data_check(runid)
path = ['..' filesep 'data' filesep runid '.mat']
load(path)
bad = parse_vnav_text_data(par, VNavData, VNavDataText);
size(bad)

function bad = parse_vnav_text_data(par, VNavData, VNavDataText)
% Converts the ASCII string data from the VectorNav to Matlab arrays.
%
% Parameters
% ----------
% handles : structure
%   Handles to gui objects and user data.
%
% Returns
% -------
% handles : structure
%   Handles to gui objects and user data.

% create parse string
ps = '%*6c';
for i=1:size(VNavData, 2)
    ps = [ps ',%g'];
end

blank = zeros(size(VNavData));

bad = {};
j = 1;

% process the text data
for i=1:par.VNavNumSamples
    try
        blank(i, :) = sscanf(VNavDataText{i}, ps);
    catch
        display(sprintf('%d is a bad one: %s', i, VNavDataText{i}))
        bad{j} = {i, VNavDataText{i}};
        j = j + 1;
    end
end
