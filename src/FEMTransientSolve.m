function [Problem] = FEMTransientSolve(Problem)
%FEMSOLVE Takes a Problem object and solves it by building a Global Matrix.
% Problem must be a valid Problem.
[~,~,~,~,GV,Problem]=globalMatrix(Problem); % Construct global matrix and other vectors.
Problem.c=GM\GV; % Solve system of matrices for c (results vector for global nodes.)
Problem.Result=Problem.c; % Copy to results field (more understandable name.)
end

