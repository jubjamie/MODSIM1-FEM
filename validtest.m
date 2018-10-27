%---System Init---%
close all
p=genpath('lib');addpath(p);p=genpath('status');addpath(p);

problemMesh=OneDimLinearMeshGen(0,1,3);
LaplaceElemMatrix(1,1,problemMesh)
