%Set up path space
startSolver;

% Create Batch based on @part2a template interating Q,TL and
% Number of Elements through
% [Lower Bounds],[Upper Bounds], [Number of Steps];
Batch=problemBatch(@cw1_part2a,[1.5 295 2],[1.5 295 8],[1 1 4]);

Batch=solveBatch(Batch); % Send to Batch solver using default @FEMSolver.

%Set Plot Options for custom plotter.
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2a Mesh Resolution Comparison (Q=1.5, TL=295)';
PlotOpts.filepath='status/part2a_res.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';

% Create cell array of Problem Titles.
PlotOpts.legend.labels={'2 Elements','4 Elements','6 Elements','8 Elements'}; 

PlotOpts.nodePlot.Color={'r','g','b',[1, 0.666, 0]}';
extraFcn='grid;';
close all

%Plot the Batch with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);