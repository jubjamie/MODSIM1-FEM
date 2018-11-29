startSolver;

close all;
Skin=Skin();
temps=[328:0.5:329];
gammas=zeros(1,size(temps,2));

parfor i=1:size(temps,2)
P2=newTransientProblem();
P2.Mesh(0,0.01,100);

%Set coefficients based on Skin


P2.Diffusion.coef=[[0,Skin.E.TC];[Skin.E.xend,Skin.D.TC];[Skin.D.xend,Skin.B.TC]];
disp(temps(i));

P2.Transient.Time=50;
P2.Transient.Theta=1;
P2.Transient.dt=0.1;
P2.ConstantInit(310.15);
P2.BCS.D=[[temps(i),0];[310.15,0.01];];
P2.Solve(false);
gammas(i)=calculateBurn(P2);
end