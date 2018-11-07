function [Titles] = getBatchTitles(Batch)
%GETBATCHTITLES Returns cell array of Titles from Problems within a Batch
%   Use for auto generating a legend for plotting or otherwise.
Titles=cell(1,size(Batch,2));
for i=1:size(Batch,2)
    if (isfield(Batch{i},'title'))
        Titles{i}=Batch{i}.title;
    else
        Titles{i}='';
    end
end
end

