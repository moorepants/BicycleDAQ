clear all; close all; clc;
fid = fopen('../HardSoftIronCalibrationNumbers.txt');
nums = fscanf(fid, '%e');
fclose(fid);
a = reshape(nums,12,length(nums)/12);
a(:,end-1:end) = [];
a(:,1:2) = [];
abar = mean(a, 2);
sigmaa = std(a, 0, 2);
percent = sigmaa./abar