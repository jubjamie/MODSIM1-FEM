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

%Logic to check for various diffusion coefs
% Coefs should come in as array of pairs.[x,D] e.g. [[0,1],[0.5,2]]
% The coef at the end will be used for the rest of the mesh
Dsize=size(D,1);
if Dsize > 1
    D(Dsize+1,:)=[msh.xmax,D(Dsize,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:Dsize+1
        if localx<abs(D(i+1,1)) && localx>=abs(D(i,1))
            D=D(i,2);
            break;
        end
    end
    
end
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
N=3;
gq=makeGQ(N);

if strcmp(msh.basisType,'Quad')
    % Quadratic Gradients
    dpsi0_dz=@(x) x-0.5;
    dpsi1_dz=@(x) -2*x;
    dpsi2_dz=@(x) 0.5+x;
else
    %Linear Gradients
    dpsi0_dz=@(x) -0.5;
    dpsi1_dz=@(x) 0.5;
end
%zx Gradients
dz_dx=2/(x1-x0);

Int00_gq=zeros(1,N);
Int01_gq=zeros(1,N);
Int11_gq=zeros(1,N);
Int02_gq=zeros(1,N);
Int12_gq=zeros(1,N);
Int22_gq=zeros(1,N);

% Ints
for i=1:N
    Int00_gq(i)=D*dpsi0_dz(gq.xipts(i))*dz_dx*dpsi0_dz(gq.xipts(i));
    Int01_gq(i)=D*dpsi0_dz(gq.xipts(i))*dz_dx*dpsi1_dz(gq.xipts(i));
    if strcmp(msh.basisType,'Quad')
        Int11_gq(i)=D*dpsi1_dz(gq.xipts(i))*dz_dx*dpsi1_dz(gq.xipts(i));
        Int02_gq(i)=D*dpsi0_dz(gq.xipts(i))*dz_dx*dpsi2_dz(gq.xipts(i));
        Int12_gq(i)=D*dpsi1_dz(gq.xipts(i))*dz_dx*dpsi2_dz(gq.xipts(i));
        Int22_gq(i)=D*dpsi2_dz(gq.xipts(i))*dz_dx*dpsi2_dz(gq.xipts(i));
    end
end
%No xi(z) to evaluate at gauss point so weights only needed
Int00=sum(Int00_gq.*gq.gsw);
Int01=sum(Int01_gq.*gq.gsw);
Int11=sum(Int11_gq.*gq.gsw);
Int02=sum(Int02_gq.*gq.gsw);
Int12=sum(Int12_gq.*gq.gsw);
Int22=sum(Int22_gq.*gq.gsw);

if strcmp(msh.basisType,'Quad')
    localElemMatrix=[Int00, Int01, Int02;
                    Int01, Int11, Int12;
                    Int02, Int12, Int22];
else
    localElemMatrix=[Int00, Int01;
                     Int01, Int00];
end
end

