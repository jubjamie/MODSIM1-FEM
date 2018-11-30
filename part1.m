startSolver;
close all
clear x y
% Creat a new transient Problem
P=newTransientProblem();
P.Mesh(0,1,10);
P.Diffusion.coef=1;
P.Transient.Theta=0.5;
P.BCS.D=[[0,0];[1,1];];
P.Solve();
fixedX=P.PlotAtX(0.8);
changeTime=P.PlotAtTime([0.05,0.1,0.3,1]);

figure(fixedX);
title('x=0.8 Varying Over Time');
hold on;
x=linspace(0,1,101);
for i=1:101
    y(i)=TransientAnalyticSoln(0.8,x(i));
end
plot(x,y,'DisplayName','Analytical Solution - x: 0.8')
saveas(fixedX,['status/cw2/part1_theta_' num2str(P.Transient.Theta) '.png']);


figure(changeTime);
title('Solution Varying Transiently');
saveas(fixedX,['status/cw2/part1_time_overview_theta' num2str(P.Transient.Theta) '.png']);

