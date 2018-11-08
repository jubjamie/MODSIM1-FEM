function [x,y,z] = compileParameterVectors(Batch,xterm,yterm)
%compileParameterVectors Loops through a batch of Problems and compiles 1xN vectors with x,y,c results.
%   (Batch,xterm,yterm)
%   Batch - Batch of Problems
%   xterm - The index of the term in the batch to use as the x axis
%   yterm - The index of the term in the batch to use as the y axis
%   
%   Outputs [x,y,z]
%   All 1xN vectors with a c (z) value for the x and y inputs parameters.
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

