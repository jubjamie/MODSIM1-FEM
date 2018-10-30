function [Problem] = part2b(Q,TL,NumOfElems)

%Init empty problem.
Problem=[];
Problem.title='Part 2B';
%Define mesh
Problem.mesh=OneDimLinearMeshGen(0,0.01,NumOfElems);
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
end

