function [Titles] = getBatchTitles(Batch)
%GETBATCHTITLES Returns cell array of Titles from Problems within a Batch
%   Use for auto generating a legend for plotting or otherwise.

Titles=cell(1,size(Batch,2)); % Pre-allocate cell array.

for i=1:size(Batch,2) % For each Problem in Batch
    if (isfield(Batch{i},'title')) % See if a title field is set.
        Titles{i}=Batch{i}.title; % Add title to array
    else
        Titles{i}=''; % Otherwise, set empty string as title.
    end
end
end

