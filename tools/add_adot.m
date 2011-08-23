function add_adot()
% adds an ADOT parameter to all runs previous to the ADOT functionality

for i = 0:70
    filename = [pad_with_zeros(num2str(i), 5) '.mat'];
    load(['../data/' filename])
    [m, n] = size(VNavData);
    if n == 12
        par.ADOT = 14;
    elseif n == 10
        par.ADOT = 253;
    end
    save(['data/' filename])
end

function num = pad_with_zeros(num, digits)
% Adds zeros to the front of a string needed to produce the number of
% digits.
%
% Parameters
% ----------
% num : string
%   A string representation of a number (i.e. '25')
% digits : integer
%   The total number of digits desired.
%
% If digits = 4 and num = '25' then the function returns '0025'.

for i = 1:digits-length(num)
    num = ['0' num];
end
