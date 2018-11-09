function [x,y,z] = compileResultProfiles(Batch,xterm,varargin)
%COMPILERESULTPROFILES Creates the vectors and matrices for drawing contorf
%                      of result profiles.
%   Given a batch and the variable term, this function produces the 3 
%   vectors/matrices for contorf to draw a variable profile of the
%   result as xterm changes.
%
%   (Batch, xterm, holdIndez(optional))
%   Batch - Batch of Problems as cell array.
%   xterm - The term to vary on the x-axis within the batch.
%   holdIndex - The nodal position/index to hold the other parameter at.
%   If not given will use middle (or closest) node.
%   NOTE: This function assumes a 2 term Batch.
%
%   Outputs [x,y,z]
%   All 1xN vectors with a c (z) value for the x and y inputs parameters.

xstep=Batch{1}.BatchOptions.STEPS(xterm); % Fetch step count for variable parameter.
xlb=Batch{1}.BatchOptions.LB(xterm); % Fetch lower bounds for variable parameter.
xub=Batch{1}.BatchOptions.UB(xterm); % Fetch upper bounds for variable parameter.
ystep=Batch{1}.mesh.ngn; % Fetch step count for variable parameter.

% Generate x,y vectors for Result Profile
x=linspace(xlb,xub,xstep);
y=Batch{1}.mesh.nvec;


% Generate z matrix for Result Profile
batchSize=xstep; % Use step count in x as number of batches to evaluate.
paramSize=Batch{1}.BatchOptions.STEPS; % Fetch STEPS vector from Batch creation

% If a specific index for the constant parameter is chosen, use this.
% Otherwise find a node index near the middle of the domain.
% Note this currently assume parameter 3 is mesh resolution and non varying.
if (size(varargin,2)==1)
    holdIndex=[varargin{1} varargin{1}];
else
    holdIndex=[round(paramSize(2)/2,0),round(paramSize(1)/2,0)];
end

% If Batch only has 1 parameter, set Batch index to equal loop index. (1-1 map)
% Else create an anonymous function that calculates the batch index depending on
% the other indexes set by this function.
if size(paramSize,2)==1
    posCounter=@(i) i;
else
if xterm==1
    %Then j loop held at value
    posCounter=@(i) ((i-1)*(paramSize(2)*paramSize(3)))+...
        ((holdIndex(xterm)-1)*paramSize(3))+paramSize(3);
else
    %i loop held at value
    posCounter=@(j) ((holdIndex(xterm)-1)*(paramSize(2)*paramSize(3)))+...
        ((j-1)*paramSize(3))+paramSize(3);
end
end

z=zeros(ystep,xstep); % Pre-allocate z matrix.
for i=1:batchSize % Loop through number of batches required to compile z matrix.
    % Set the z element to the result that corresponds to the correct
    % varying parameter value.
    z(:,round(x,5)==round(Batch{posCounter(i)}.initParams(xterm),5))=...
        Batch{posCounter(i)}.Result;
end
end

