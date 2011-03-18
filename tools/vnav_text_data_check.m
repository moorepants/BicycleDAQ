function vnav_text_data_check(runid)
% Loads a run mat file and figures out the bad data in VNavDataText.
path = ['..' filesep 'data' filesep runid '.mat']
load(path)
bad = parse_vnav_text_data(par, VNavData, VNavDataText);
size(bad)

function bad = parse_vnav_text_data(par, VNavData, VNavDataText)
% Trys to convert the ASCII string data from the VectorNav to a Matlab array,
% but if it can't it stores the value in bad and displays it.
%
% Parameters
% ----------
% par : structure
%   The parameters from a run.
% VNavData : matrix
%   Contains the original parsing of the VNavDataText.
% VNavDataText : cell array
%   Contains the strings ouput by the VectorNav in async mode.
%
% Returns
% -------
% bad : cell array
%   The contains the indices and strings for the bad strings in VNavDataText.

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
