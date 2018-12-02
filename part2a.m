startSolver;

close all;

P2=newTransientProblem();
P2.Mesh(0,0.01,100);

%Set coefficients based on Skin
Skin=Skin();

P2.Diffusion.coef=[[0,Skin.E.TC];[Skin.E.xend,Skin.D.TC];[Skin.D.xend,Skin.B.TC]];

P2.Transient.Time=50;
P2.Transient.Theta=1;
P2.Transient.dt=0.1;
P2.ConstantInit(310.15);
P2.BCS.D=[[393.15,0];[310.15,0.01];];
P2.basisType='Quad';
P2.Solve();
changeTime=P2.PlotAtTime([0.05,0.5,2,5,50]);
figure(changeTime);
plotSkin;
disp(['Gamma: ' num2str(calculateBurn(P2))]);
saveas(changeTime,['status/cw2/timeoverview_2a_' P2.basisType '.png']);
