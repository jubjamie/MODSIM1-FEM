function [x,y,z] = createSurfaceVectors(Batch,xterm,yterm)
%CREATESURFACEVACTORS Deprecated function used to find the peak result value, match with x,y inputs ready for surface plotting.
%   Not required for cw problems as all max result values are bound at the boundaries.
batchSize=Batch{1}.BatchOptions.BatchSize;
x=zeros(1,batchSize);
y=zeros(1,batchSize);
z=zeros(1,batchSize);
for i=1:batchSize
    x(i)=Batch{i}.initParams(xterm);
    y(i)=Batch{i}.initParams(yterm);
    z(i)=max(Batch{i}.Result);
end

end

