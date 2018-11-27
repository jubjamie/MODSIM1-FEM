function [localElemMatrix] = LaplaceElemMatrix(D,eID,msh)
%LAPLACEELEMMATRIX Creates the diffusion localElem Matrix.
%   (D, eID, mesh)
%   D - The diffusion coefficent to use in the matrix.
%   eID - The ID of the element to create the local element matrix for.
%   msh - The mesh object for the problem.
% Local element properties within mesh can accessed as follows:
%   Pos-x0: msh.elem(eID).x(1);   GlobalNodeID-x0: msh.elem(eID).n(1);
%   Pos-x1: msh.elem(eID).x(2);   GlobalNodeID-x1: msh.elem(eID).n(2);
%   Element Jacobian: msh.elem(eID).J;

%Convert element boundary x values info to convinienet variable names.

x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);
%{
Int00=D/(x1-x0);    % Short forms as derived in report derivation.
Int01=-D/(x1-x0);

localElemMatrix=[Int00, Int01;Int01, Int00]; % Assemble into 2x2 matrix.
%}

%Four combinations of integral written as [Int00,Int01;Int10,Int11];
%Int00=IntF(D*dpsi0_dz*dz_dx*dpsi0_dz*dz_dx*J)dz<>[-1,1];-----------\
%Int01=IntF(D*dpsi0_dz*dz_dx*dpsi1_dz*dz_dx*J)dz<>[-1,1]; --\Equiv   \
%Int10=IntF(D*dpsi1_dz*dz_dx*dpsi0_dz*dz_dx*J)dz<>[-1,1]; --/Equiv   / Will be equal (See #report section)
%Int11=IntF(D*dpsi1_dz*dz_dx*dpsi1_dz*dz_dx*J)dz<>[-1,1];-----------/

%Use GQ
N=2;
gq=makeGQ(N);

% Linear gradients for now.
dpsi0_dz=-0.5;
dpsi1_dz=0.5;
dz_dx=2/(x1-x0);

Int00_gq=zeros(1,N);
Int01_gq=zeros(1,N);

% Int00
for i=1:N
    Int00_gq(i)=D*dpsi0_dz*dz_dx*dpsi0_dz;
end
%No xi(z) to evaluate at gauss point so weights only needed
Int00=sum(Int00_gq.*gq.gsw);

% Int01
for i=1:N
    Int01_gq(i)=D*dpsi0_dz*dz_dx*dpsi1_dz;
end
%No xi(z) to evaluate at gauss point so weights only needed
Int01=sum(Int01_gq.*gq.gsw);

localElemMatrix=[Int00, Int01;Int01, Int00];

end

