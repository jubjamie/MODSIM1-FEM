function [Problem] = part1ciProblem(NumOfElems)
%PART1CIPROBLEM Summary of this function goes here
%   Detailed explanation goes here
Problem=[];
%Define problem.
Problem.mesh=OneDimLinearMeshGen(0,1,NumOfElems);
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem.Diffusion.LE.coef=1;
Problem.BCS.D=[[0,1];[2,0];];
end

