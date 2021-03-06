function [x,y,z] = generateContorMatrices(Batch,xterm,yterm,zpos)
%GENERATECONTORMATRICES Generates matrices and vectors for a 2 way contor
%   plot of 2 varied terms within a batch at a certain index of the result.
%   These vectors and matrices can be used by the contorf function to display
%   parameter dependance at a certain result node (i.e. certain x in the equation.)
%
%   (Batch, xterm, yterm, zpos)
%   Batch - A batch of problems that cover the parameter space with it's 
%           containing functions.
%   xterm - The term in the Batch to be used on the x axis.
%   yterm - The term in the Batch to be used on the y axis.
%   zpos - The index of the results vector to use as the analysis point.
%
%   Outputs
%   x,y,z - The required x,y,z for contorf.

%Find size of x
xstep=Batch{1}.BatchOptions.STEPS(xterm); % Fetch steps for variable parameter.
xlb=Batch{1}.BatchOptions.LB(xterm); % Fetch lower bounds for variable parameter.
xub=Batch{1}.BatchOptions.UB(xterm); % Fetch upper bounds for variable parameter.
ylb=Batch{1}.BatchOptions.LB(yterm); % Fetch lower bounds for variable parameter.
yub=Batch{1}.BatchOptions.UB(yterm); % Fetch upper bounds for variable parameter.
ystep=Batch{1}.BatchOptions.STEPS(yterm); % Fetch steps for variable parameter.

% Generate x,y vectors for Contor
x=linspace(xlb,xub,xstep);
y=linspace(ylb,yub,ystep);

batchSize=Batch{1}.BatchOptions.BatchSize; % Fetch batch size from BatchOptions
z=zeros(ystep,xstep); % Pre-allocate z.

for i=1:batchSize
    % Place each batch in the element corresponding to the parameters for x and y.
    z(round(y,5)==round(Batch{i}.initParams(yterm),5),round(x,5)...
        ==round(Batch{i}.initParams(xterm),5))...
        =Batch{i}.Result(zpos);
end

end

