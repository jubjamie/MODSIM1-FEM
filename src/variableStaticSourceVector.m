function [sourceLocalElem] = variableStaticSourceVector(sourcecoef,eID,msh,varargin)
%SOURCEVECTOR Creates a custom function for the FEM Solver to construct the

J=msh.elem(eID).J;
x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);

scSize=size(sourcecoef,1);
if scSize > 1
    sourcecoef(scSize+1,:)=[msh.xmax,sourcecoef(scSize,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:scSize+1
        if localx<abs(sourcecoef(i+1,1)) && localx>=abs(sourcecoef(i,1))
            sourcecoef=sourcecoef(i,2);
            break;
        end
    end
   
end

%Use GQ
if ~isempty(varargin)
    assert(~mod(cell2mat(varargin(1)),1),...
        'Gaussian Quadrature Scheme must be integer');
    N=cell2mat(varargin(1));
else
    N=3;
end
gq=makeGQ(N);

% Linear gradients for now.

Int0_gq=zeros(1,N);
Int1_gq=zeros(1,N);
Int2_gq=zeros(1,N);

psi0=@(z) (z.*(z-1))./2;
psi1=@(z) 1-z.^2;
psi2=@(z) (z.*(1+z))./2;

% Int00
Int0_gq=sourcecoef.*psi0(gq.xipts).*J;
Int1_gq=sourcecoef.*psi1(gq.xipts).*J;
Int2_gq=sourcecoef.*psi2(gq.xipts).*J;

%No xi(z) to evaluate at gauss point so weights only needed
Int0=sum(Int0_gq.*gq.gsw);
Int1=sum(Int1_gq.*gq.gsw);
Int2=sum(Int2_gq.*gq.gsw);


sourceLocalElem=[Int0,Int1,Int2]';
end

