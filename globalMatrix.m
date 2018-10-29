function [M,c] = globalMatrix(Problem)
%GLOBALMATRIX Returns Global Matrix filled with local elems
%Size is NxN and.
%Also returns solution column vector initialised to zero

%% Init matricies
%Get problem info from mesh
N=Problem.mesh.ngn;
c=zeros(N,1);
M=zeros(N);

%% Generate Basic Global and Soltuion
%Top left corner
M(1:2,1:2)=Problem.LE.Generator(Problem.LE.coef,1,Problem.mesh);
for i=2:N-1
%loop through each local elem matrix
M(i:i+1,i:i+1)=M(i:i+1,i:i+1)+Problem.LE.Generator(Problem.LE.coef,i,Problem.mesh);
end

M
c
end

