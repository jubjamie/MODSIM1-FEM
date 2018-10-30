%---System Init---%
close all
p=genpath('lib');addpath(p);p=genpath('status');addpath(p);

problemMesh=OneDimLinearMeshGen(0,1,3);
%Part 1a
LaplaceElemMatrix(1,1,problemMesh)
%Part 1b
ReactionElemMatrix(1,1,problemMesh)
problemMesh=OneDimLinearMeshGen(0,1,6);
ReactionElemMatrix(1,1,problemMesh)

%{
%Part 1c
%Make global matrix and c vector from lecture
Problem.mesh=OneDimLinearMeshGen(0,1,4);
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem.Diffusion.LE.coef=1;
Problem.BCS.D=[[0,1];[2,0];];
[M,c,f,BCrhs,Problem]=globalMatrix(Problem);
Problem.c=M\f;
Problem.c
%}
%{
%Part 1cii
%Make global matrix and c vector from lecture
Problem.mesh=OneDimLinearMeshGen(0,1,4);
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem.Reaction.LE.Generator=@ReactionElemMatrix;
Problem.Diffusion.LE.coef=1;
Problem.Reaction.LE.coef=0;
Problem.BCS.D=[[0,1];];
Problem.BCS.N=[[2,0];];
[M,c,f,BCrhs,Problem]=globalMatrix(Problem);
Problem.c=M\f;
Problem.c

%}

%Part 1d
%Make global matrix and c vector from lecture
Problem=[];
Problem.mesh=OneDimLinearMeshGen(0,1,10);
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
Problem.Reaction.LE.Generator=@ReactionElemMatrix;
Problem.Diffusion.LE.coef=1;
Problem.Reaction.LE.coef=-9;
Problem.f.coef=0;
Problem.BCS.D=[[0,0];[1,1];];
[M,c,f,BCrhs,Problem]=globalMatrix(Problem);
Problem.c=M\f;
Problem.c

%1d analytic answers
x=Problem.mesh.nvec;
p1dSol=(exp(3)/(exp(6)-1))*(exp(3*x)-exp(-3*x))
