[~,part2bProblem] = part2b(1,300,5);
[~,part2aProblem] = part2a(0.5,300,5);
%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2 Mesh Comparison Results';
PlotOpts.filepath='status/part2b.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';
PlotOpts.nodePlot.Color={'r','b'};
PlotOpts.legend.labels={part2bProblem.title,part2aProblem.title};
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution({part2bProblem,part2aProblem},PlotOpts,extraFcn);