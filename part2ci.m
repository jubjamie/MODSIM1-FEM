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
P2C.Transient.dt=0.1;
P2C.ConstantInit(310.15);
P2C.BCS.D=[[393.15,0];[310.15,0.01];];
P2C.Solve();
changeTime=P2C.PlotAtTime([2,5,10]);
calculateBurn(P2C)