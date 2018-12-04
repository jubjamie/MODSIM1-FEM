function [Problem] = FEMTransientSolve(Problem,varargin)
%FEMTRANSIENTSOLVE Takes a Transient Problem object and solves it.

% Detect optional flag to prevent plotting live solutions.
if ~isempty(varargin{1})
    doplot=cell2mat(varargin{1});
else
    doplot=true;
end

%Set up a progress bar to give estimation of time remaining
progressbar('Solving Time Steps');

% Calculate solving steps
Ne=Problem.mesh.ne;
steps=round(Problem.Transient.Time/Problem.Transient.dt);

% Set global matrix assembly version, init temporary solution matrix and
%create x-domain for plotting depending on whether basis function type is linear or quadratic.
if strcmp(Problem.basisType,'Quad')
    disp('Solving using Quadratic Basis Functions');
    transientsolution=zeros((2*Ne)+1,steps+1);
    nvecConvert=linspace(Problem.mesh.xmin,Problem.mesh.xmax,(2*Problem.mesh.ne)+1);
    globalAssembler=@(x) globalMatrixTransient(Problem);
else
    disp('Solving using Linear Basis Functions');
    nvecConvert=Problem.mesh.nvec;
    transientsolution=zeros(Problem.mesh.ngn,steps+1);
    globalAssembler=@(x) globalMatrixTransientLinear(Problem);
end

% Set temporary solution matrix first time step as defined by the Problem
transientsolution(:,1)=Problem.c;

if doplot % Create figure for plotting if plotting requested
    figure(5);
    hold off;
end

% Loop through each timestep and solve.
for i=2:steps+1
    progressbar(i/steps); % update progress bar
    [GM,GV,Problem]=globalAssembler(Problem); % Assemble global matrix/vector
    Problem.c=GM\GV; % Set new current solution
    transientsolution(:,i)=Problem.c; % Store solution in matrix
    
    if mod(i,10)==0 && doplot % Plot graph every 10th timestep if requested
        figure(5);
        plot(nvecConvert,Problem.c');
        legend(['Time: ' num2str(i*Problem.Transient.dt) 's']);
    end
end

Problem.Solution=transientsolution; % Update problem object with final solution.
progressbar(1); % Close progress bar.
end

