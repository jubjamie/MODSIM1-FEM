%---System Init---%
close all
p=genpath('lib');addpath(p);p=genpath('status');addpath(p);

problemMesh=OneDimLinearMeshGen(0,1,3);
%Part 1a
LaplaceElemMatrix(1,1,problemMesh)
%Part 1b
ReactionElemMatrix(1,1,problemMesh)
