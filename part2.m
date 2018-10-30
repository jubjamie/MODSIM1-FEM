[c,part2bProblem] = part2b(1,300,5);
%Set Plot Options
PlotOpts.title='Part 2b Mesh Result';
PlotOpts.filepath='status/part2b.png';
PlotOpts.x.label='x';
PlotOpts.y.label='Temperature (K)';
close all
plotSolution(part2bProblem,PlotOpts);
%[c,part2aProblem] = part2a(1,300,5);