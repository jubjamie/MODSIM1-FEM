function [M,c,f,Problem] = globalMatrix(Problem)
%GLOBALMATRIX Returns Global Matrix filled with local elems
%Size is NxN and.
%Also returns solution column vector initialised to zero

%% Init matricies
%Get problem info from mesh
N=Problem.mesh.ngn;
c=zeros(N,1);
M=zeros(N);
f=Problem.f;

%% Generate Basic Global and Soltuion
%Top left corner
M(1:2,1:2)=Problem.LE.Generator(Problem.LE.coef,1,Problem.mesh);
for i=2:N-1
%loop through each local elem matrix
M(i:i+1,i:i+1)=M(i:i+1,i:i+1)+Problem.LE.Generator(Problem.LE.coef,i,Problem.mesh);
end

%% Enforce Dirichlet BCs
for j=1:size(Problem.BCS.D,1)
BCd=Problem.BCS.D(j,:);
%Calcualte equiv row for BC position x
equivRow=(BCd(2)*(N-1))+1;
assert(~mod(N,1),'Boundary condition not specified for a node'); %Checks N is of integer even if type is doulbe from above division.
M(equivRow,:)=0;
f(equivRow)=BCd(1);
M(equivRow,equivRow)=1;
end


%% Clean up
Problem.M=M;
Problem.c=c;
Problem.f=f;

end

