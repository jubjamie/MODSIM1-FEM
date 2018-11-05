startSolver;

Batch=problemBatch(@part1dProblem,[2],[6],[3]);

Batch=solveBatch(Batch);

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 1d Mesh Resolution Comparison Results';
PlotOpts.x.label='x';
PlotOpts.y.label='c';
PlotOpts.filepath='status/part1d_MeshComparison.png';
PlotOpts.legend.labels=getBatchTitles(Batch);
PlotOpts.legend.pos='Northwest';
PlotOpts.nodePlot.Color={'r','m','g'}';
PlotOpts.nodePlot.LineStyle='--';
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);
xvals=linspace(0,1,100);
expectedSolFcn=(exp(3)/(exp(6)-1)*(exp(3*xvals)-exp(-3*xvals)));
plot(xvals,expectedSol,'LineStyle','-','Color','k','DisplayName','Analytical Solution');

Batch{1}=RMS(Batch{1});
Batch{1}.RMS
