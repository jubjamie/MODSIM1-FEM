function [Problem] = FEMTransientSolve(Problem)
%FEMSOLVE Takes a Problem object and solves it by building a Global Matrix.
% Problem must be a valid Problem.
steps=round(Problem.Transient.Time/Problem.Transient.dt);
transientsolution=zeros(Problem.mesh.ngn,steps+1);
transientsolution(:,1)=Problem.c;
for i=2:steps
    [GM,GV,Problem]=globalMatrixTransient(Problem); % Construct global matrix and other vectors.
    Problem.c=GM\GV; % Solve system of matrices for c (results vector for global nodes.)
    Problem.Result=Problem.c; % Copy to results field (more understandable name.)
    transientsolution(:,i)=Problem.c;
end
Problem.Solution=transientsolution;
end

