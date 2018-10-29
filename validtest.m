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


%Part 1c
%Make global matrix and c vector from lecture
Problem.mesh=OneDimLinearMeshGen(0,1,3);
Problem.LE.Generator=@LaplaceElemMatrix;
Problem.LE.coef=1;
[M,c]=globalMatrix(Problem);