%%Set up path space
startSolver;

% Create Batch based on @part2a template interating Q,TL and Number of Elements through
% [Lower Bounds],[Upper Bounds], [Number of Steps];
Batch=problemBatch(@part2a,[0.5 294.15 5],[1.5 322.15 5],[5 5 1]);

Batch=solveBatch(Batch); % Send to Batch solver using default @FEMSolver.

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2a Coef Comparison Results';
PlotOpts.filepath='status/part2a_comp.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';
%PlotOpts.legend.labels=getBatchTitles(Batch);
%PlotOpts.nodePlot.Color={'r','g','b',[1, 0.666, 0]}';
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);

%3D plot max positions.

f3=figure('Name','Parameter Space - Part 2a - Constant x Position');
heldXindex=2;
[x,y,z]= generateContorMatricies(Batch,1,2,heldXindex);
[cc,hh]=contourf(x,y,z,14,'ShowText','on');
hh.LevelStep=1;
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('TL (K)');
zlabel('c value');
heldXpos=((heldXindex-1)/Batch{1}.mesh.ne)*(Batch{1}.mesh.xmax-Batch{1}.mesh.xmin);
title(['Variation in Temperature at x=' num2str(round(heldXpos,3)) 'm with Q and TL']);
colorbar;
saveas(f3,'status/part2a_contor.png');


%Plot how temp profile varies with TL
f4=figure('pos',[400,400,820,475],'Name','Temperature Profile - Part 2a - Varying TL');
holdPindex=2;
[x,y,z]= compileResultProfiles(Batch,2,holdPindex);
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,8,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('TL (K)');
ylabel('x (m)');
zlabel('c value');
holdPvalue=(((Batch{1}.BatchOptions.UB(1)-Batch{1}.BatchOptions.LB(1))/(Batch{1}.BatchOptions.STEPS(1)-1))*(holdPindex-1))+Batch{1}.BatchOptions.LB(1);
title(['Part 2a Temperature Profile as TL Only Varies. Q=' num2str(holdPvalue)]);
colorbar;
saveas(f4,'status/part2a_profile.png');

%Plot how temp profile varies with Q
f5=figure('pos',[400,400,820,475],'Name','Temperature Profile - Part 2a - Varying Q');
[x,y,z]= compileResultProfiles(Batch,1,2);
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,12,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('x (m)');
zlabel('c value');
title('Part 2a Temperature Profile as Q Only Varies');
colorbar;
saveas(f5,'status/part2a_profile_Q.png');

