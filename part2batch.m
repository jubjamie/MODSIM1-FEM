%%Set up path space
p=genpath('lib');addpath(p);p=genpath('status');addpath(p);p=genpath('src');addpath(p);

Batch=problemBatch(@part2a,[0.5 294.15 5],[1.5 322.15 5],[3 3 1]);
Batch=solveBatch(Batch);

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2a Coef Comparison Results';
PlotOpts.filepath='status/part2a_comp.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);