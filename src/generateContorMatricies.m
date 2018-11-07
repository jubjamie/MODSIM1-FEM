function [x,y,z] = generateContorMatricies(Batch,xterm,yterm,zpos)
%GENERATECONTORMATRICIES Generates matricies and vectors for a 2 way contor plot of 2 varied terms within a batch at a certain index of the result..
%   These vectors and matricies can be used by the contorf function to display parameter dependance at a certain result node (i.e. certain x in the equation.)
%   (Batch, xterm, yterm, zpos)
%   Batch - A batch of problems that cover the parameter space with it's containing functions.
%   xterm - The term in the Batch to be used on the x axis.
%   yterm - The term in the Batch to be used on the y axis.
%   zpos - The index of the results vector to use as the analysis point.
%
%   Outputs
%   x,y,z - The required x,y,z for contorf.

%Find size of x
xstep=Batch{1}.BatchOptions.STEPS(xterm);
xlb=Batch{1}.BatchOptions.LB(xterm);
xub=Batch{1}.BatchOptions.UB(xterm);
ystep=Batch{1}.BatchOptions.STEPS(yterm);
ylb=Batch{1}.BatchOptions.LB(yterm);
yub=Batch{1}.BatchOptions.UB(yterm);
x=linspace(xlb,xub,xstep);
y=linspace(ylb,yub,ystep);
batchSize=Batch{1}.BatchOptions.BatchSize;
z=zeros(ystep,xstep);
for i=1:batchSize
    z(round(y,5)==round(Batch{i}.initParams(yterm),5),round(x,5)==round(Batch{i}.initParams(xterm),5))=Batch{i}.Result(zpos);
end

end

