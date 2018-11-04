function [x,y,z] = compileParameterVectors(Batch,xterm,yterm)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nodeCount=Batch{1}.BatchOptions.TotalNodes;
batchSize=Batch{1}.BatchOptions.BatchSize;
nodeTracker=1;
x=zeros(1,nodeCount);
y=zeros(1,nodeCount);
z=zeros(1,nodeCount);
for i=1:batchSize
    newNodes=Batch{i}.mesh.ngn;
    x(nodeTracker:nodeTracker+newNodes-1)=Batch{i}.initParams(xterm);
    y(nodeTracker:nodeTracker+newNodes-1)=Batch{i}.initParams(yterm);
    z(nodeTracker:nodeTracker+newNodes-1)=Batch{i}.Result';
    nodeTracker=nodeTracker+newNodes;
end
assert(nodeTracker-1==nodeCount,'Final nodeTracker does not match expected totalNodes');
end

