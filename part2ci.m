startSolver;

close all;

P2C=newTransientProblem();
P2C.Mesh(0,0.01,100);

%Set coefficients based on Skin
Skin=Skin();

P2C.Diffusion.coef=[[0,Skin.E.TC];[Skin.E.xend,Skin.D.TC];[Skin.D.xend,Skin.B.TC]];
P2C.Reaction.coef=-[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS];[Skin.D.xend,Skin.B.HS]];
P2C.f.coef=[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS*Skin.D.Tb];[Skin.D.xend,Skin.B.HS*Skin.B.Tb]];

P2C.Transient.Time=50;
P2C.Transient.Theta=1;
P2C.Transient.dt=0.05;
P2C.BCS.D=[[393.15,0];[310.15,0.01];];
P2C.ConstantInit(310.15);
P2C.basisType='Quad';
P2C.Solve(false);
changeTime=P2C.PlotAtTime([0.05,0.5,2,5,50]);
figure(changeTime);
plotSkin;
saveas(changeTime,['status/cw2/timeoverview_2ci_theta_' num2str(P2.basisType) '_' P2.basisType '.png']);
contor2ci=figure();
[x,y,z] = generateTransientProfile(P2C,5);
contourf(x,y,z,100,'ShowText','off','LineColor','none');
saveas(contor2ci,['status/cw2/contor2ci_' P2C.basisType '.png']);
gamma=calculateBurn(P2C);