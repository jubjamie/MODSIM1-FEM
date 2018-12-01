startSolver;
close all
clear x y
% Creat a new transient Problem
P=newTransientProblem();
P.Mesh(0,1,10);
P.Diffusion.coef=1;
P.Transient.dt=0.01;
P.BCS.D=[[0,0];[1,1];];
P.Solve();
fixedX=P.PlotAtX(0.8);
changeTime=P.PlotAtTime([0.05,0.1,0.3,1]);
timeStepCount=(P.Transient.Time/P.Transient.dt)+1;
figure(fixedX);
title('x=0.8 Varying Over Time - Crank Nicolson');
hold on;
x=linspace(0,1,timeStepCount);
for i=1:timeStepCount
    y(i)=TransientAnalyticSoln(0.8,x(i));
end
plot(x,y,'DisplayName','Analytical Solution - x: 0.8')
saveas(fixedX,['status/cw2/part1_theta_' num2str(P.Transient.Theta) '.png']);


figure(changeTime);
title('Solution Varying Transiently - Crank Nicolson');
legend('Location','Northwest');
saveas(changeTime,['status/cw2/part1_time_overview_theta_' num2str(P.Transient.Theta) '.png']);

% Creat a new transient Problem for Backwards Euler
PE=newTransientProblem();
PE.Mesh(0,1,10);
PE.Diffusion.coef=1;
PE.Transient.Theta=1;
PE.BCS.D=[[0,0];[1,1];];
PE.Solve();
fixedXE=PE.PlotAtX(0.8);
changeTimeE=PE.PlotAtTime([0.05,0.1,0.3,1]);
timeStepCountE=(PE.Transient.Time/PE.Transient.dt)+1;
figure(fixedXE);
title('x=0.8 Varying Over Time - Backwards Euler');
hold on;
xE=linspace(0,1,timeStepCountE);
for i=1:timeStepCountE
    yE(i)=TransientAnalyticSoln(0.8,xE(i));
end
plot(xE,yE,'DisplayName','Analytical Solution - x: 0.8');
saveas(fixedXE,['status/cw2/part1_theta_' num2str(PE.Transient.Theta) '.png']);


figure(changeTimeE);
title('Solution Varying Transiently - Backwards Euler');
legend('Location','Northwest');
saveas(changeTimeE,['status/cw2/part1_time_overview_theta_' num2str(PE.Transient.Theta) '.png']);

errorCompare=figure();
hline(0,'k--');
hold on
plot(x,(y-P.GetValuesAtX(0.8)),'r-','DisplayName','Crank-Nicolson Error');
plot(xE,(yE-PE.GetValuesAtX(0.8)),'b-','DisplayName','Backward Euler Error');
legend('Location','Northeast');

