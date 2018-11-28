startSolver;
close all
P=newTransientProblem();
P.Mesh(0,1,10);
P.Diffusion.coef=1;
P.Reaction.coef=0;
P.Transient.Time=1;
P.ConstantInit(0);
P.BCS.D=[[0,0];[1,1];];
P.Solve();
P.PlotAtX(0.8);
P.PlotAtTime([0.05,0.1,0.3,1]);

x=linspace(0,10,11);
for i=1:11
    y(i)=TransientAnalyticSoln(x(i),0.05);
end
figure(2)
plot(x,y)
