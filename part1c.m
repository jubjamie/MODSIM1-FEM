startSolver;

%Make Problem for Part 1ci with two D-BCs
Problem=[]; % Init an empty Problem object.
Problem.mesh=OneDimLinearMeshGen(0,1,4); % Define the mesh with 4 elements x=0<>1
Problem.Diffusion.LE.coef=1; % Set a diffusion coefficient of 1.
Problem.BCS.D=[[2,0];[0,1];]; % Define Dirichlet Boundaries-> c=2@x=0 & c=0@x=1

Problem=FEMSolve(Problem); % Send Problem to FEM Solver.

%Set Plot Options for custom plotter.
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 1ci Solution';
PlotOpts.filepath='status/part1ci.png';
PlotOpts.x.label='x';
PlotOpts.y.label='c';
PlotOpts.legend.labels={'Part 1ci - 2 D BCs'};
PlotOpts.legend.pos='Southwest';
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution({Problem},PlotOpts,extraFcn);

%Part 1cii using the example D/N BCs
Problem2=[]; % Init an empty Problem object.
Problem2.mesh=OneDimLinearMeshGen(0,1,4); % Define the mesh with 4 elements x=0<>1
Problem2.Diffusion.LE.coef=1; % Set a diffusion coefficient of 1.
Problem2.BCS.D=[[0,1];]; % Define Dirichlet BC -> c=0@x=1
Problem2.BCS.N=[[2,0];]; % Define Neumann BC -->dc/dx=2@x=0;

Problem2=FEMSolve(Problem2); % Send Problem to FEM Solver.

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 1cii Comparison';
PlotOpts.filepath='status/part1cii_compare.png';
PlotOpts.x.label='x';
PlotOpts.y.label='c';
PlotOpts.legend.labels={'Part 1ci - 2D BCs','Part 1cii - 1D, 1N BCs'};
PlotOpts.legend.pos='West';
PlotOpts.nodePlot.Color={'r','g'}';
extraFcn='grid;';

%Plot the solution with dedicated function.
plotSolution({Problem, Problem2},PlotOpts,extraFcn);