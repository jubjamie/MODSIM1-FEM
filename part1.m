startSolver;
close all
clear x y xE yE

x_point=0.8; % Used for error analysis and x plotting.
jointBT='Linear'; % Sets basis type for both problems.

% Creat a new transient Problem
P=newTransientProblem();
P.Mesh(0,1,10); % Create mesh.
P.Diffusion.coef=1; % Set diffusion coef to 1
P.Transient.dt=0.001; % Set timestep to 0.001
P.Transient.Theta=0.5; % Set method to Crank Nicolson using theta schemes
P.BCS.D=[[0,0];[1,1];]; % Set Dirichlet BCs in form [c,x];
P.basisType=jointBT; % Set basis function type.
P.Solve(); % Solve the problem

% -Plotting- %
% Uses methods of the class to do heavy lifting of plotting correct points.
fixedX=P.PlotAtX(x_point); % Plot x point at all times
changeTime=P.PlotAtTime([0.05,0.1,0.3,1]); % Plot all x at different times.
timeStepCount=(P.Transient.Time/P.Transient.dt)+1; % Calculate number of steps

figure(fixedX); % Load into gcf
title(['x=' num2str(x_point) ' Varying Over Time - Crank Nicolson']);
hold on;
% Make analytical solution
x=linspace(0,1,timeStepCount);
for i=1:timeStepCount
    y(i)=TransientAnalyticSoln(x_point,x(i));
end
plot(x,y,'DisplayName',['Analytical Solution - x:' num2str(x_point)])
saveas(fixedX,['status/cw2/part1_theta_' num2str(P.Transient.Theta) '_dt_' num2str(P.Transient.dt) '_' P.basisType '.png']);


figure(changeTime); % Load into gcf
title('Solution Varying Transiently - Crank Nicolson');
legend('Location','Northwest');
saveas(changeTime,['status/cw2/part1_time_overview_theta_' num2str(P.Transient.Theta) '_dt_' num2str(P.Transient.dt) '_' P.basisType '.png']);

% Creat a new transient Problem for Backwards Euler
PE=newTransientProblem();
PE.Mesh(0,1,10); % Create mesh.
PE.Diffusion.coef=1; % Set diffusion coef to 1
PE.Transient.Theta=1; % Set method to backwards Euler using theta schemes
PE.Transient.dt=0.001; % Set timestep to 0.001
PE.BCS.D=[[0,0];[1,1];]; % Set Dirichlet BCs in form [c,x];
PE.basisType=jointBT; % Set basis function type.
PE.Solve(); % Solve the problem

% -Plotting- %
% Uses methods of the class to do heavy lifting of plotting correct points.
fixedXE=PE.PlotAtX(x_point); % Plot x point at all times
changeTimeE=PE.PlotAtTime([0.05,0.1,0.3,1]); % Plot all x at different times.
timeStepCountE=(PE.Transient.Time/PE.Transient.dt)+1; % Calculate number of steps

figure(fixedXE); % Load into gcf
title(['x=' num2str(x_point) ' Varying Over Time - Backwards Euler']);
hold on;
% Make analytical solution
xE=linspace(0,1,timeStepCountE);
for i=1:timeStepCountE
    yE(i)=TransientAnalyticSoln(x_point,xE(i));
end
plot(xE,yE,'DisplayName',['Analytical Solution - x: ' num2str(x_point)]);
saveas(fixedXE,['status/cw2/part1_theta_' num2str(PE.Transient.Theta) '_dt_' num2str(P.Transient.dt) '_' PE.basisType '.png']);


figure(changeTimeE); % Load into gcf
title('Solution Varying Transiently - Backwards Euler');
legend('Location','Northwest');
saveas(changeTimeE,['status/cw2/part1_time_overview_theta_' num2str(PE.Transient.Theta) '_dt_' num2str(P.Transient.dt) '_' PE.basisType '.png']);

% Compare errors at xpoint
errorCompare=figure();
hline(0,'k--');
hold on;
% Plot error for CN Method
plot(x,(y-P.GetValuesAtX(x_point)),'r-','DisplayName','Crank-Nicolson Error');
% Plot error for BE Method
plot(xE,(yE-PE.GetValuesAtX(x_point)),'b-','DisplayName','Backward Euler Error');
xlabel('Time (s)');
ylabel('Error (Ce-Cx)');
legend('Location','Northeast');
title(['Error from Analytical Solution at x=' num2str(x_point)]);
grid on;
saveas(errorCompare,['status/cw2/part1_error_x-' num2str(x_point) '_dt_' num2str(P.Transient.dt) '_' PE.basisType '.png']);