startSolver;

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