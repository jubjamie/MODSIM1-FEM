function [Problem] = FEMSolve(Problem)
%FEMSOLVE Takes a Problem object and solves it by building a Global Matrix.
% Problem must be a valid Problem.
[M,~,f,~,Problem]=globalMatrix(Problem); % Construct global matrix and other vectors.
Problem.c=M\f; % Solve system of matricies for c (results vector for global nodes.)
Problem.Result=Problem.c; % Copy to results field (more understanable name.)
end

