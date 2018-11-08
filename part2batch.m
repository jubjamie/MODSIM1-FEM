%Set up path space
startSolver;

% Create Batch based on @part2a template interating Q,TL and Number of Elements through
% [Lower Bounds],[Upper Bounds], [Number of Steps];
Batch=problemBatch(@part2a,[0.5 294.15 10],[1.5 322.15 10],[5 5 1]);

Batch=solveBatch(Batch); % Send to Batch solver using default @FEMSolver.

% Set Plot Options for custom plotter.
% Note output of this graph not used in report. Available online.
PlotOpts=[]; %Clear previous opts.
PlotOpts.title='Part 2a Coef Comparison Results'; % Plot Title.
PlotOpts.filepath='status/part2a_comp.png'; % Indicate file should be saved here.
PlotOpts.x.label='x (m)'; % xaxis label
PlotOpts.y.label='Temperature (K)'; % yaxis label
extraFcn='grid;'; % string input of matlab commands that should also be ran.
close all

%Plot the solution with dedicated function.
plotSolution(Batch,PlotOpts,extraFcn);


% Plot contor plot showing how temperature at fixed x varies in Q and TL
f3=figure('Name','Parameter Space - Part 2a - Constant x Position');
heldXindex=4; % Specify index of domain vector to evalute.
% Make the required matricies for contorf from the Batch.
[x,y,z]= generateContorMatricies(Batch,1,2,heldXindex);
% Plot contorf plot with some options.
[cc,hh]=contourf(x,y,z,17,'ShowText','on');
hh.LevelStep=1;
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
clabel(cc,hh)
xlabel('Q');
ylabel('TL (K)');
zlabel('c value');
% Calculate the x position in the domain from the index to use in title.
heldXpos=((heldXindex-1)/Batch{1}.mesh.ne)*(Batch{1}.mesh.xmax-Batch{1}.mesh.xmin);
title(['Variation in Temperature at x=' num2str(round(heldXpos,3)) 'm with Q and TL']);
% Dispaly the colorbar before saving.
colorbar;
saveas(f3,'status/part2a_contor.png');


%Plot how temp profile varies with TL
f4=figure('pos',[400,400,820,475],'Name','Temperature Profile - Part 2a - Varying TL');
holdPindex=4; % Specify index of Q values to hold constant.
% Make the required matricies for contorf from the Batch.
[x,y,z]= compileResultProfiles(Batch,2,holdPindex);
% Plot contorf plot with some options.
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
% Overlay classic contor on top with some options.
[cc,hh]=contour(x,y,z,9,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
clabel(cc,hh)
xlabel('TL (K)');
ylabel('x (m)');
zlabel('c value');
% Calculate the value of Q being held constant to use in title.
holdPterm=1;
holdPvalue=(((Batch{1}.BatchOptions.UB(holdPterm)-Batch{1}.BatchOptions.LB(holdPterm))/(Batch{1}.BatchOptions.STEPS(holdPterm)-1))*(holdPindex-1))+Batch{1}.BatchOptions.LB(holdPterm);
title(['Part 2a Temperature Profile as TL Only Varies. Q=' num2str(holdPvalue)]);
% Dispaly the colorbar before saving.
colorbar;
saveas(f4,'status/part2a_profile.png');

%Plot how temp profile varies with Q
f5=figure('pos',[400,400,820,475],'Name','Temperature Profile - Part 2a - Varying Q');
holdPindex=1; % Specify index of Q values to hold constant.
% Make the required matricies for contorf from the Batch.
[x,y,z]= compileResultProfiles(Batch,1,holdPindex);
% Plot contorf plot with some options.
contourf(x,y,z,50,'ShowText','off','LineColor','none');
hold on
% Overlay classic contor on top with some options.
[cc,hh]=contour(x,y,z,9,'ShowText','on','LineColor','k');
hh.LevelList=round(hh.LevelList,0);  %rounds levels to 3rd decimal place
clabel(cc,hh)
xlabel('Q');
ylabel('x (m)');
zlabel('c value');
% Calculate the value of TL being held constant to use in title.
holdPterm=2;
holdPvalue=(((Batch{1}.BatchOptions.UB(holdPterm)-Batch{1}.BatchOptions.LB(holdPterm))/(Batch{1}.BatchOptions.STEPS(holdPterm)-1))*(holdPindex-1))+Batch{1}.BatchOptions.LB(holdPterm);
title(['Part 2a Temperature Profile as Q Only Varies. TL=' num2str(holdPvalue)]);
% Dispaly the colorbar before saving.
colorbar;
saveas(f5,'status/part2a_profile_Q.png');

