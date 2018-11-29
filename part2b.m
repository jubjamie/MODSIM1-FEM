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
opts = optimset('fminsearch');
opts.Display = 'iter'; %What to display in command window
opts.TolX = 0.5; %Tolerance on the variation in the parameters
opts.TolFun = 1e15; %Tolerance on the error
opts.MaxIter = 30; %Max number of iterations
[x, diff, exitflag] = fminsearchbnd(@(x)burnCostFunction(x,P2), [353.15], [315.15], [393.15], opts);
