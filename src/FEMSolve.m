function [Problem] = FEMSolve(Problem)
%FEMSOLVE Takes a Problem object and solves it by building a Global Matrix.
% Problem must be a valid Problem.
[M,~,f,~,Problem]=globalMatrix(Problem);
Problem.c=M\f;
Problem.Result=Problem.c;
end

