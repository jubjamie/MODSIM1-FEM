%%Set up path space
startSolver;

% Create Batch based on @part2a template interating Q,TL and Number of Elements through
% [Lower Bounds],[Upper Bounds], [Number of Steps];
Batcha=problemBatch(@part2a,[0.5 294.15 10],[1.5 322.15 10],[2 2 1]);
Batcha=solveBatch(Batcha); % Send to Batch solver using default @FEMSolver.
Batchb=problemBatch(@part2b,[0.5 294.15 10],[1.5 322.15 10],[2 2 1]);

Batchb=solveBatch(Batchb); % Send to Batch solver using default @FEMSolver.

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2a Parameter Extremities Comparison';
PlotOpts.filepath='status/part2b_comp_mini.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';
PlotOpts.legend.labels=[strcat('Part a:',getBatchTitles(Batcha)) strcat('Part b:',getBatchTitles(Batchb))];
PlotOpts.nodePlot.Color={'r','g','b',[1, 0.666, 0],'r','g','b',[1, 0.666, 0]}';
PlotOpts.nodePlot.LineStyle={'--','--','--','--','-','-','-','-'};
extraFcn='grid;set(gca,''fontsize'',12);set(gcf, ''Position'', [100, 100, 800, 650])';
close all

%Plot the solution with dedicated function.
plotSolution([Batcha, Batchb],PlotOpts,extraFcn);