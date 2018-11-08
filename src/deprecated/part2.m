%%Set up path space
startSolver;

%Generate Problem using part2 quick templates (variable inputs Q,TL,No. of Elems);
part2bProblem = part2b(1,300,5);
part2aProblem = part2a(1,300,5);
part2bProblem = FEMSolve(part2bProblem);
part2aProblem = FEMSolve(part2aProblem);

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2 a) & b) Mesh Comparison Results';
PlotOpts.filepath='status/part2b.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';
PlotOpts.nodePlot.Color={'b','r'}';
PlotOpts.legend.labels={[part2aProblem.title ' Q=1, TL=300 - Static Source Term Q.TL'],[part2bProblem.title ' Q=1, TL=300 - Linear Source Term Q.TL.(1+4x)']};
extraFcn='grid;';
close all

probs2plot={part2aProblem,part2bProblem};

%Plot the solution with dedicated function.
plotSolution(probs2plot,PlotOpts,extraFcn);