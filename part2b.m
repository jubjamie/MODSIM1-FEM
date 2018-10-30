function [c,Problem] = part2b(Q,TL)
%Init empty problem.
Problem.title='Part 2B';
%Define mesh
Problem.mesh=OneDimLinearMeshGen(0,0.01,5);
%Define Local element Generator functions
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem.Reaction.LE.Generator=@ReactionElemMatrix;
k=1.01e-5;
%Set coefficients
Problem.Diffusion.LE.coef=k;
Problem.Reaction.LE.coef=-Q;
Problem.f.coef=Q*TL;
Problem.f.fcn=@(x) Q*TL*(1+(4*x));
%Set BCs
Problem.BCS.D=[[323.15,0];[293.15,0.01];];
[M,~,f,~,Problem]=globalMatrix(Problem);
Problem.c=M\f;
c=Problem.c;
Problem.c;

%Set Plot Options

PlotOpts.filepath='status/part2b.png';
PlotOpts.x.label='x';
PlotOpts.y.label='Temperature (K)';
PlotOpts.nodePlot.LineStyle='-';
PlotOpts.nodePlot.Color='r';
PlotOpts.nodePlot.Marker='o';
PlotOpts.nodePlot.MarkerEdgeColor='k';
plotSolution(Problem,PlotOpts);
end

