function [Problem] = FEMTransientSolve(Problem,varargin)
%FEMSOLVE Takes a Problem object and solves it by building a Global Matrix.
% Problem must be a valid Problem.
if ~isempty(varargin{1})
    doplot=cell2mat(varargin{1});
else
    doplot=true;
end
Ne=Problem.mesh.ne;    
progressbar('Solving Time Steps');
steps=round(Problem.Transient.Time/Problem.Transient.dt);
if strcmp(Problem.basisType,'Quad')
    disp('Solving using Quadratic Basis Functions');
transientsolution=zeros((2*Ne)+1,steps+1);
nvecConvert=linspace(Problem.mesh.xmin,Problem.mesh.xmax,(2*Problem.mesh.ne)+1);
globalSolver=@(x) globalMatrixTransient(Problem);
else
    disp('Solving using Linear Basis Functions');
    nvecConvert=Problem.mesh.nvec;
    transientsolution=zeros(Problem.mesh.ngn,steps+1);
    globalSolver=@(x) globalMatrixTransientLinear(Problem);
end
transientsolution(:,1)=Problem.c;
if doplot
    figure(5);
    hold off;
end
for i=2:steps+1
    progressbar(i/steps);
    [GM,GV,Problem]=globalSolver(Problem); % Construct global matrix and other vectors.
    Problem.c=GM\GV; % Solve system of matrices for c (results vector for global nodes.)
    Problem.Result=Problem.c; % Copy to results field (more understandable name.)
    transientsolution(:,i)=Problem.c;
    if mod(i,10)==0 && doplot
        figure(5);
        plot(nvecConvert,Problem.Result');
        legend(['Time: ' num2str(i*Problem.Transient.dt) 's']);
    end
end
Problem.Solution=transientsolution;
progressbar(1);
end

