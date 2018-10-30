function [Problem] = part2a(Q,TL,NumOfElems)

%Init empty problem.
Problem=[];
Problem.title='Part 2A';
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
%Set BCs
Problem.BCS.D=[[323.15,0];[293.15,0.01];];

end