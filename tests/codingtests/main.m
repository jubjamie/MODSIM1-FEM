%---System Init---%
close all
p=genpath('lib');addpath(p);p=genpath('status');addpath(p);

%Create mesh
problemMesh=OneDimLinearMeshGen(0,10,10);

for i=1:problemMesh.ne
    LaplaceElemMatrix(0,i,problemMesh);
end