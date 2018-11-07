%%Set up path space
startSolver;

% Create Batch based on @part2a template interating Q,TL and Number of Elements through
% [Lower Bounds],[Upper Bounds], [Number of Steps];
Batch=problemBatch(@part2a,[0.5 294.15 10],[1.5 322.15 10],[2 2 1]);

Batch=solveBatch(Batch); % Send to Batch solver using default @FEMSolver.

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2a Coef Comparison Results';
PlotOpts.filepath='status/part2a_comp_mini.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';
PlotOpts.legend.labels=getBatchTitles(Batch);
PlotOpts.nodePlot.Color={'r','g','b',[1, 0.666, 0]}';
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);