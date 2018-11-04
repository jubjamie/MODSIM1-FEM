function [x,y,z] = createSurfaceVectors(Batch,xterm,yterm)
%CREATESURFACEVACTORS Summary of this function goes here
%   Detailed explanation goes here
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

