% Solve simple case with no blood flow and burn temp of 393.15K

startSolver;

close all;

% Make new problem
P2C=newTransientProblem();
P2C.Mesh(0,0.01,100); % Set up mesh


%Set coefficients based on Skin and make skin object
Skin=Skin();

%Set coefficents as region array of values from skin object
P2C.Diffusion.coef=[[0,Skin.E.TC];[Skin.E.xend,Skin.D.TC];...
                    [Skin.D.xend,Skin.B.TC]];
P2C.Reaction.coef=-[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS];...
                    [Skin.D.xend,Skin.B.HS]];
P2C.f.coef=[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS*Skin.D.Tb];...
                    [Skin.D.xend,Skin.B.HS*Skin.B.Tb]];

% Set up solver settings
P2C.Transient.Time=50;
P2C.Transient.Theta=1;
P2C.Transient.dt=0.005;
P2C.BCS.D=[[393.15,0];[310.15,0.01];];
P2C.ConstantInit(310.15);
P2C.basisType='Quad';
% Solve
P2C.Solve(false);

% Plot required figures
changeTime=P2C.PlotAtTime([0.05,0.5,2,5,50]);
figure(changeTime);
plotSkin;
disp(['Gamma: ' num2str(calculateBurn(P2C))]);
title(['Transient Numerical Solution - Theta: ' num2str(P2C.Transient.Theta)...
    ', dt: ' num2str(P2C.Transient.dt) ' Using ' P2C.basisType ' Basis Functions']);
saveas(changeTime,['status/cw2/timeoverview_2ci_theta_' P2C.basisType '.png']);

% Make contor plot
contor2ci=figure();
[x,y,z] = generateTransientProfile(P2C,5);
contourf(x,y,z,100,'ShowText','off','LineColor','none');
colorbar;
hline([Skin.E.xend,Skin.D.xend],'k--');
xlabel('Time (s)');
ylabel('Position (x)');
zlabel('Temperature');
title('Graphical Representation for First 5 Seconds');
saveas(contor2ci,['status/cw2/contor2ci_' P2C.basisType '.png']);

% Calculate gamma from curn function
gamma=calculateBurn(P2C);