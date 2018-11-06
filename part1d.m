startSolver; %#ok<*NBRAK>

Batch=problemBatch(@part1dProblem,[2],[6],[3]); % Create a batch of problems using the 
                                    %@part1dProblem Template iterating template input 1 (# of elems)
                                    % from 2 to 6 in 3 steps.

Batch=solveBatch(Batch); % Send the Batch of Problems to the Batch Solver using default @FEMSolve

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
