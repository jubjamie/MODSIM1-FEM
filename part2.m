[~,part2bProblem] = part2b(1,300,5);
%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2 Mesh Comparison Results';
PlotOpts.filepath='status/part2b.png';
PlotOpts.x.label='x';
PlotOpts.y.label='Temperature (K)';
PlotOpts.nodePlot.Color={'r','b'};
extraFcn='grid;';
close all
[~,part2aProblem] = part2a(0.5,300,5);
plotSolution({part2bProblem,part2aProblem},PlotOpts,extraFcn);