startSolver;

% Create a batch of problems using the 
% @part1dProblem Template iterating template input 1 (# of elems)
% from 2 to 6 in 3 steps.
Batch=problemBatch(@part1dProblem,[2],[6],[3]); 

% Send the Batch of Problems to the Batch Solver using default @FEMSolve
Batch=solveBatch(Batch); 

%Set Plot Options for custom plotter.
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 1d Mesh Resolution Comparison Results';
PlotOpts.x.label='x';
PlotOpts.y.label='c';
PlotOpts.legend.labels=getBatchTitles(Batch);
PlotOpts.legend.pos='Northwest';
PlotOpts.nodePlot.Color={'b','r','g'}';
PlotOpts.nodePlot.LineStyle={'--','--','--'};
extraFcn='grid;';
close all

% Plot the Batch with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);

% Plot analytical solution.
xvals=linspace(0,1,101); % Create x domain.
expectedSol=(exp(3)/(exp(6)-1)*(exp(3*xvals)-exp(-3*xvals))); % Solve @ x.
plot(xvals,expectedSol,'LineStyle','-','Color','k','DisplayName','Analytical Solution');
saveas(gcf,'status/part1d_MeshComparison.png');