function [Batch] = solveBatch(Batch,varargin)
%SOLVEBATCH Loops through each Batch and solves using specified solver.
%   (Batch, solver function(optional))
%   Batch - A batch of problems to be solved.
%   solver function - A function handle to a solving function. If not provided the default FEM solver is used.
%
%   Outputs
%   Batch - Returns the batched with each Problem solved.
if (size(varargin,2)==1)
    %means solver is specified
    solver=varargin{1};
else
    %Specify default FEM Solver
    solver=@FEMSolve;
end
BatchSize=size(Batch,2);
for i=1:BatchSize
    Batch{i}=solver(Batch{i});
end

end

