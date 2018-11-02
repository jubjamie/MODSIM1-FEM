function [Problem] = FEMSolve(Problem)
%FEMSOLVE Takes a Problem object and solves it using Global Matrix.
[M,~,f,~,Problem]=globalMatrix(Problem);
Problem.c=M\f;
Problem.Result=Problem.c;
end

