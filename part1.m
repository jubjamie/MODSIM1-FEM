startSolver;
close all
clear x y xE yE

x_point=0.8; % Used for error analysis and x plotting.
jointBT='Quad'; % Sets basis type for both problems.

% Creat a new transient Problem
P=newTransientProblem();
P.Mesh(0,1,10);
P.Diffusion.coef=1;
%P.Transient.dt=0.001;
P.Transient.Theta=0.5;
P.BCS.D=[[0,0];[1,1];];
P.basisType=jointBT;
P.Solve();
fixedX=P.PlotAtX(x_point);
changeTime=P.PlotAtTime([0.05,0.1,0.3,1]);
timeStepCount=(P.Transient.Time/P.Transient.dt)+1;
figure(fixedX);
title(['x=' num2str(x_point) ' Varying Over Time - Crank Nicolson']);
hold on;
x=linspace(0,1,timeStepCount);
for i=1:timeStepCount
    y(i)=TransientAnalyticSoln(x_point,x(i));
end
plot(x,y,'DisplayName',['Analytical Solution - x:' num2str(x_point)])
saveas(fixedX,['status/cw2/part1_theta_' num2str(P.Transient.Theta) '_' P.basisType '.png']);


figure(changeTime);
title('Solution Varying Transiently - Crank Nicolson');
legend('Location','Northwest');
saveas(changeTime,['status/cw2/part1_time_overview_theta_' num2str(P.Transient.Theta) '_' P.basisType '.png']);

% Creat a new transient Problem for Backwards Euler
PE=newTransientProblem();
PE.Mesh(0,1,10);
PE.Diffusion.coef=1;
PE.Transient.Theta=1;
PE.BCS.D=[[0,0];[1,1];];
PE.basisType=jointBT;
PE.Solve();
fixedXE=PE.PlotAtX(x_point);
changeTimeE=PE.PlotAtTime([0.05,0.1,0.3,1]);
timeStepCountE=(PE.Transient.Time/PE.Transient.dt)+1;
figure(fixedXE);
title(['x=' num2str(x_point) ' Varying Over Time - Backwards Euler']);
hold on;
xE=linspace(0,1,timeStepCountE);
for i=1:timeStepCountE
    yE(i)=TransientAnalyticSoln(x_point,xE(i));
end
plot(xE,yE,'DisplayName',['Analytical Solution - x: ' num2str(x_point)]);
saveas(fixedXE,['status/cw2/part1_theta_' num2str(PE.Transient.Theta) '_' PE.basisType '.png']);


figure(changeTimeE);
title('Solution Varying Transiently - Backwards Euler');
legend('Location','Northwest');
saveas(changeTimeE,['status/cw2/part1_time_overview_theta_' num2str(PE.Transient.Theta) '_' PE.basisType '.png']);

errorCompare=figure();
hline(0,'k--');
hold on;
plot(x,(y-P.GetValuesAtX(x_point)),'r-','DisplayName','Crank-Nicolson Error');
plot(xE,(yE-PE.GetValuesAtX(x_point)),'b-','DisplayName','Backward Euler Error');
xlabel('Time (s)');
ylabel('Error (Ce-Cx)');
legend('Location','Northeast');
title(['Error from Analytical Solution at x=' num2str(x_point)]);
saveas(errorCompare,['status/cw2/part1_error_x-' num2str(x_point) '_' PE.basisType '.png']);