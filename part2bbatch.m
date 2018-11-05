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

f=figure(10);
[x,y,z]= generateContorMatricies(Batch,1,2,3);
[cc,hh]=contourf(x,y,z,10,'ShowText','on');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('TL');
zlabel('c value');
saveas(f,'status/part2b_contor.png');


%Plot how temp profile varies with TL
f11=figure('pos',[400,400,620,475]);
[x,y,z]= compileResultProfiles(Batch,2,2);
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,12,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('TL');
ylabel('x');
zlabel('c value');
saveas(f11,'status/part2b_profile.png');

%Plot how temp profile varies with Q
f12=figure('pos',[400,400,620,475]);
[x,y,z]= compileResultProfiles(Batch,1,5);
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,6,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('x');
zlabel('c value');
saveas(f12,'status/part2b_profile_Q.png');

%% Compare to part2a.
Batch2a=problemBatch(@part2a,[0.5 294.15 5],[1.5 322.15 5],[5 5 1]);
Batch2a=solveBatch(Batch2a);

%Plot difference between a and b.
f13=figure('pos',[400,400,620,475]);
[x,y,z]= compileResultProfiles(Batch,2,5);
[~,~,z2a]= compileResultProfiles(Batch2a,2,5);
z=z-z2a;
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
[cc,hh]=contour(x,y,z,6,'ShowText','on','LineColor','k');
hh.LevelStep=1;
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('TL');
ylabel('x');
zlabel('c value');
saveas(f13,'status/part2a_b_profile_comp.png');

f14=figure(14);
[x,y,z2b]= generateContorMatricies(Batch,1,2,2);
[~,~,z2a]= generateContorMatricies(Batch2a,1,2,2);
z=z2b-z2a;
[cc,hh]=contourf(x,y,z,10,'ShowText','on');
hh.LevelStep=0.2;
hh.LevelList=round(hh.LevelList,2);  %rounds levels to 3rd decimal place
  clabel(cc,hh)
xlabel('Q');
ylabel('TL');
zlabel('c value');
saveas(f14,'status/part2a_b_contor_comp.png');
