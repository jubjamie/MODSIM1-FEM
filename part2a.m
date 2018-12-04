% Solve simple case with no blood flow and burn temp of 393.15K

startSolver;

close all;

% Make new problem
P2=newTransientProblem();
P2.Mesh(0,0.01,100); % Set up mesh

%Set coefficients based on Skin and make skin object
Skin=Skin();

%Set diffusion coefficent as region array of values from skin object
P2.Diffusion.coef=[[0,Skin.E.TC];[Skin.E.xend,Skin.D.TC];[Skin.D.xend,Skin.B.TC]];

% Set up solver settings
P2.Transient.Time=50;
P2.Transient.Theta=1;
P2.Transient.dt=0.005;
P2.ConstantInit(310.15);
P2.BCS.D=[[393.15,0];[310.15,0.01];];
P2.basisType='Quad';
% Solve
P2.Solve(false);

% Plot required figures
changeTime=P2.PlotAtTime([0.05,0.5,2,5,50]);
figure(changeTime);
plotSkin;
disp(['Gamma: ' num2str(calculateBurn(P2))]);
title(['Transient Numerical Solution - Theta: ' num2str(P2.Transient.Theta) ', dt: ' num2str(P2.Transient.dt) ' Using ' P2.basisType ' Basis Functions']);
saveas(changeTime,['status/cw2/timeoverview_2a_theta_' P2.basisType '.png']);

% Make contor plot
contor2ai=figure();
[x,y,z] = generateTransientProfile(P2,5);
contourf(x,y,z,100,'ShowText','off','LineColor','none');
colorbar;
hline([Skin.E.xend,Skin.D.xend],'k--');
xlabel('Time (s)');
ylabel('Position (x)');
zlabel('Temperature');
title('Graphical Representation for First 5 Seconds');
saveas(contor2ai,['status/cw2/contor2ai_' P2.basisType '.png']);

% Calculate gamma from curn function
gamma=calculateBurn(P2);