function [Problem] = part1dProblem(NumOfElems)
%PART1DPROBLEM Summary of this function goes here
%   Detailed explanation goes here
Problem=[];
Problem.title=[num2str(NumOfElems) ' Elements'];
Problem.mesh=OneDimLinearMeshGen(0,1,NumOfElems);
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem.Reaction.LE.Generator=@ReactionElemMatrix;
Problem.Diffusion.LE.coef=1;
Problem.Reaction.LE.coef=-9;
Problem.f.coef=0;
Problem.BCS.D=[[0,0];[1,1];];
end

