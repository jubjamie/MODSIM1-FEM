function [x,y,z] = compileResultProfiles(Batch,xterm,varargin)
%COMPILERESULTPROFILES Creates the vectors and matricies for drawing contorf of result profiles.
%   Given a batch and the variable term, this function produces the 3 vectors/matricies for contorf to draw a variable profile of the result as xterm changes.
%   (Batch, xterm, holdIndez(optional))
%   Batch - Batch of Problems.
%   xterm - The term to vary on the x-axis within the batch.
%   holdIndex - The nodal position/index to hold the other parameter at. If not given will use middle (or closest) node.
%   NOTE: This function assumes a 2 term Batch. #TODO Single term batch.
%
%   Outputs [x,y,z]
%   All 1xN vectors with a c (z) value for the x and y inputs parameters.

xstep=Batch{1}.BatchOptions.STEPS(xterm);
xlb=Batch{1}.BatchOptions.LB(xterm);
xub=Batch{1}.BatchOptions.UB(xterm);
ystep=Batch{1}.mesh.ngn;
ylb=min(Batch{1}.mesh.nvec);
yub=max(Batch{1}.mesh.nvec);
x=linspace(xlb,xub,xstep);
y=linspace(ylb,yub,ystep);
batchSize=xstep;
paramSize=Batch{1}.BatchOptions.STEPS;
if (size(varargin,2)==1)
    holdIndex=[varargin{1} varargin{1}];
else
    holdIndex=[round(paramSize(2)/2,0),round(paramSize(1)/2,0)];
end
if xterm==1
    %Then j loop held at value
    posCounter=@(i) ((i-1)*(paramSize(2)*paramSize(3)))+((holdIndex(xterm)-1)*paramSize(3))+paramSize(3);
else
    %i loop held at value
    posCounter=@(j) ((holdIndex(xterm)-1)*(paramSize(2)*paramSize(3)))+((j-1)*paramSize(3))+paramSize(3);
end
z=zeros(ystep,xstep);
for i=1:batchSize
    z(:,round(x,5)==round(Batch{posCounter(i)}.initParams(xterm),5))=Batch{posCounter(i)}.Result;
end
end

