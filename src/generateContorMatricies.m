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
xstep=Batch{1}.BatchOptions.STEPS(xterm); % Fetch step count for variable parameter.
xlb=Batch{1}.BatchOptions.LB(xterm); % Fetch lower bounds for variable parameter.
xub=Batch{1}.BatchOptions.UB(xterm); % Fetch upper bounds for variable parameter.

% Generate x,y vectors for Contor
x=linspace(xlb,xub,xstep);
y=Batch{1}.mesh.nvec;

batchSize=Batch{1}.BatchOptions.BatchSize; % Fetch batch size from BatchOptions
z=zeros(ystep,xstep); % Pre-allocate z.

for i=1:batchSize
    % Place each batch in the element corresponding to the parameters for x and y.
    z(round(y,5)==round(Batch{i}.initParams(yterm),5),round(x,5)...
        ==round(Batch{i}.initParams(xterm),5))...
        =Batch{i}.Result(zpos);
end

end

