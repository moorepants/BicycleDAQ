function switch_x_z(directory)
% function switch_x_z(directory)
%
% Goes through every file in the given directory and switches the
% FrameAccelX input pair with the FrameAccelZ input pair. For runs 0-226 the
% wires were plugged into the wrong inputs. Switching the values in
% InputPairs in all of the runs seemed like the easiest solution to the
% issue.

% get all the matlab related files in the directory
matStuff = what(directory);

% list of all mat files
matFiles = matStuff.mat;

for i = 1:length(matFiles)
    load([matStuff.path filesep matFiles{i}]);

    oldFrameAccelX = InputPairs.FrameAccelX;
    oldFrameAccelZ = InputPairs.FrameAccelZ;

    InputPairs.FrameAccelX = oldFrameAccelZ;
    InputPairs.FrameAccelZ = oldFrameAccelX;

    save([matStuff.path filesep matFiles{i}], 'InputPairs', '-append')

    clear InputPairs NIData VNavCols VNavData VNavDataText par
end
