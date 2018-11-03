function [Titles] = getBatchTitles(Batch)
%GETBATCHTITLES Summary of this function goes here
%   Detailed explanation goes here
Titles=cell(1,size(Batch,2));
for i=1:size(Batch,2)
    Titles{i}=Batch{i}.title;    
end
end

