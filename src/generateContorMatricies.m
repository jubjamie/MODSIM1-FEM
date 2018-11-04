function [x,y,z] = generateContorMatricies(Batch,xterm,yterm,zpos)
%GENERATECONTORMATRICIES Summary of this function goes here
%   Detailed explanation goes here
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

