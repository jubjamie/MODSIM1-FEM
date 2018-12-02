function [localElemMatrix] = ReactionElemMatrix(lambda,eID,msh,varargin)
%LAPLACEELEMMATRIX Creates the reaction local element matrix.
%   (lambda, eID, mesh)
%   lambda - The reaction coefficent to use in the matrix.
%   eID - The ID of the element to create the local element matrix for.
%   msh - The mesh object for the problem.
% Local element properties within mesh can accessed as follows:
%   Pos-x0: msh.elem(eID).x(1);   GlobalNodeID-x0: msh.elem(eID).n(1);
%   Pos-x1: msh.elem(eID).x(2);   GlobalNodeID-x1: msh.elem(eID).n(2);
%   Element Jacobian: msh.elem(eID).J;

%Convert mesh info to convinienet variable names.
J=msh.elem(eID).J;
x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);

%Logic to check for various diffusion coefs
% Coefs should come in as array of pairs.[x,D] e.g. [[0,1],[0.5,2]]
% The coef at the end will be used for the rest of the mesh
lambdasize=size(lambda,1);
if lambdasize > 1
    lambda(lambdasize+1)=[msh.xmax,lambda(end,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:lambdasize+1
        if localx<abs(lambda(i+1,1)) && localx>=abs(lambda(i,1))
            lambda=lambda(i,2);
            break;
        end
    end
   
end

%{
Int00=(2/3)*lambda*J; % Calculate element values as in report derivation.
Int01=(1/3)*lambda*J;

localElemMatrix=[Int00, Int01;Int01, Int00]; % Assemble into 2x2 matrix.
%}

%Int00=INT(lambda*psi0*psi0*J)dz
%Int01=INT(lambda*psi1*psi0*J)dz

%Use GQ
if ~isempty(varargin)
    gq=varargin{1};
else
    gq=makeGQ(3);
end

% Linear gradients for now.

Int00_gq=zeros(1,gq.npts);
Int01_gq=zeros(1,gq.npts);
Int11_gq=zeros(1,gq.npts);
Int02_gq=zeros(1,gq.npts);
Int12_gq=zeros(1,gq.npts);
Int22_gq=zeros(1,gq.npts);

if strcmp(msh.basisType,'Quad')
psi0=@(z) (z.*(z-1))./2;
psi1=@(z) 1-z.^2;
psi2=@(z) (z.*(1+z))./2;
else
psi0=@(z) (1-z)./2;
psi1=@(z) (1+z)./2;
end

Int00_gq=lambda.*psi0(gq.xipts).*psi0(gq.xipts).*J;
Int01_gq=lambda.*psi0(gq.xipts).*psi1(gq.xipts).*J;
if strcmp(msh.basisType,'Quad')
Int11_gq=lambda.*psi1(gq.xipts).*psi1(gq.xipts).*J;
Int02_gq=lambda.*psi0(gq.xipts).*psi2(gq.xipts).*J;
Int12_gq=lambda.*psi1(gq.xipts).*psi2(gq.xipts).*J;
Int22_gq=lambda.*psi2(gq.xipts).*psi2(gq.xipts).*J;
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

