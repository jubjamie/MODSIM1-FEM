%%Set up path space
p=genpath('lib');addpath(p);p=genpath('status');addpath(p);p=genpath('src');addpath(p);

Batch=problemBatch(@part2a,[0.5 294.15 5],[1.5 322.15 5],[4 4 1]);
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

%3D plot max positions.
f=figure(3);
[x,y,z]= generateContorMatricies(Batch,1,2,4);
contourf(x,y,z,10,'ShowText','on');
xlabel('Q');
ylabel('TL');
zlabel('c value');
saveas(f,'status/part2a_contor.png');
