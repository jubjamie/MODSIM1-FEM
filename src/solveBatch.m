function [Batch] = solveBatch(Batch)
%SOLVEBATCH Loops through each Batch and solves using specified solver.
%   (Batch, solver function(optional))
%   Batch - A batch of problems to be solved.
%   solver function - A function handle to a solving function. 
%   If not provided the default FEM solver is used.
%
%   Outputs
%   Batch - Returns the batched with each Problem solved.

BatchSize=size(Batch,2); % Calulate number of problems in Batch
for i=1:BatchSize % Iterate through Problems in Batch
    % Solve using the specified solver of the default @FEMSolve.
    Batch{i}.Solve; 
end

end

