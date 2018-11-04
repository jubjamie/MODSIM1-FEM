startSolver;

%Part 1ci with two D-BCs
Problem=[];
%Define problem.
Problem.mesh=OneDimLinearMeshGen(0,1,4);
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem.Diffusion.LE.coef=1;
Problem.BCS.D=[[0,1];[2,0];];

Problem=FEMSolve(Problem);

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 1ci Solution';
PlotOpts.filepath='status/part1ci.png';
PlotOpts.x.label='x';
PlotOpts.y.label='c';
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution({Problem},PlotOpts,extraFcn);

%Part 1cii using the example D/N BCs
Problem2=[];
%Define problem.
Problem2.mesh=OneDimLinearMeshGen(0,1,4);
Problem2.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem2.Diffusion.LE.coef=1;
Problem2.BCS.D=[[0,1];];
Problem2.BCS.N=[[2,0];];

Problem2=FEMSolve(Problem2);

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 1cii Comparison';
PlotOpts.filepath='status/part1cii_compare.png';
PlotOpts.x.label='x';
PlotOpts.y.label='c';
PlotOpts.legend.labels={'Part 1ci - 2 D BCs','Part 1cii - 1D 1N BCs'};
PlotOpts.legend.pos='West';
PlotOpts.nodePlot.Color={'r','g'}';
extraFcn='grid;';

%Plot the solution with dedicated function.
plotSolution({Problem, Problem2},PlotOpts,extraFcn);