%%Set up path space
startSolver;

Batch=problemBatch(@part2b,[0.5 294.15 5],[1.5 322.15 5],[5 5 1]);
Batch=solveBatch(Batch);

%Set Plot Options
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2b Coef Comparison Results';
PlotOpts.filepath='status/part2b_comp.png';
PlotOpts.x.label='x (m)';
PlotOpts.y.label='Temperature (K)';
extraFcn='grid;';
close all

%Plot the solution with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);

%3D plot max positions.

f10=figure('Name','Parameter Space - Part 2b - Constant x Position');
[x,y,z]= generateContorMatricies(Batch,1,2,3);
[cc,hh]=contourf(x,y,z,10,'ShowText','on');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('TL (K)');
zlabel('c value');
title('Variation in Temperature at Constant x Position with Q and TL');
colorbar;
saveas(f10,'status/part2b_contor.png');


%Plot how temp profile varies with TL
f11=figure('pos',[0,400,620,475],'Name','Temperature Profile - Part 2b - Varying TL');
[x,y,z]= compileResultProfiles(Batch,2,2);
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,12,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('TL (K)');
ylabel('x (m)');
zlabel('c value');
title('Part 2b Temperature Profile as TL Only Varies');
colorbar;
saveas(f11,'status/part2b_profile.png');

%Plot how temp profile varies with Q
f12=figure('pos',[400,0,620,475],'Name','Temperature Profile - Part 2b - Varying Q');
[x,y,z]= compileResultProfiles(Batch,1,5);
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,12,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('x (m)');
zlabel('c value');
title('Part 2b Temperature Profile as Q Only Varies');
colorbar;
saveas(f12,'status/part2b_profile_Q.png');

%% Compare to part2a.
Batch2a=problemBatch(@part2a,[0.5 294.15 5],[1.5 322.15 5],[5 5 1]);
Batch2a=solveBatch(Batch2a);

%Plot difference between a and b.

%Show effect on temperature profile by subtraction.
f13=figure('pos',[400,500,620,475],'Name','Subtraction Camparison Parts 2 a/b');
[x,y,z]= compileResultProfiles(Batch,2,5);
[~,~,z2a]= compileResultProfiles(Batch2a,2,5);
z=z-z2a;
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,6,'ShowText','on','LineColor','k');
hh.LevelStep=1;
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('TL (K)');
ylabel('x (m)');
zlabel('c value');
title('Part 2a/b Difference as TL Varies');
colorbar;
saveas(f13,'status/part2a_b_profile_comp.png');

%{
%Doesn't show enough information.
f14=figure('Name','Part 2a/b Subtraction Comparison');
[x,y,z2b]= generateContorMatricies(Batch,1,2,2);
[~,~,z2a]= generateContorMatricies(Batch2a,1,2,2);
z=z2b-z2a;
[cc,hh]=contourf(x,y,z,10,'ShowText','on');
hh.LevelStep=0.2;
hh.LevelList=round(hh.LevelList,2);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('x (m)');
zlabel('c value');
title('Part 2b Temperature Profile as Q Only Varies');
colorbar;
saveas(f14,'status/part2a_b_contor_comp.png');
%}
