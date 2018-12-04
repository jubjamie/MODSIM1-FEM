function [sourceLocalElem] = variableStaticSourceVector(sourcecoef,eID,msh,varargin)
%SOURCEVECTOR Creates a custom function for the FEM Solver to construct the
%             the source vector for a constant source term.
%   sourcecoef - The source coefficents to use in the vector.
%   eID - The ID of the element to create the local source vector for.
%   msh - The mesh object for the problem.
%   varargin - Optional, prebuilt GQ scheme object

J=msh.elem(eID).J;
x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);


% Logic to check for various source coefs
% Coefs should come in as array of pairs.[x,sourcecoef] e.g. [[0,1],[0.5,2]]
% If a single coef is input, just use that.
% The coef at the end will be used for the rest of the mesh
scSize=size(sourcecoef,1);
if scSize > 1
    sourcecoef(scSize+1,:)=[msh.xmax,sourcecoef(scSize,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:scSize+1
        % Find region that element is in and use corresponding coef
        if localx<abs(sourcecoef(i+1,1)) && localx>=abs(sourcecoef(i,1))
            sourcecoef=sourcecoef(i,2);
            break;
        end
    end
    
end

% Use premade GQ as optionally specified. Otherwise make one at scheme 3
% Using a premade scheme as input instead of generating one here reduces
% run time by approx 25% when analysed by MATLAB profiler.
if ~isempty(varargin)
    gq=varargin{1};
else
    gq=makeGQ(3);
end

% Set basis functions gradients as required
if strcmp(msh.basisType,'Quad')
    psi0=@(z) (z.*(z-1))./2;
    psi1=@(z) 1-z.^2;
    psi2=@(z) (z.*(1+z))./2;
else
    psi0=@(z) (1-z)./2;
    psi1=@(z) (1+z)./2;
end

% Ints
Int0_gq=sourcecoef.*psi0(gq.xipts).*J;
Int1_gq=sourcecoef.*psi1(gq.xipts).*J;
if strcmp(msh.basisType,'Quad')
    Int2_gq=sourcecoef.*psi2(gq.xipts).*J;
end

% Multiply by gauss weights and sum
Int0=sum(Int0_gq.*gq.gsw);
Int1=sum(Int1_gq.*gq.gsw);

%Arrange local element vector as appropiate
if strcmp(msh.basisType,'Quad')
    Int2=sum(Int2_gq.*gq.gsw);
    sourceLocalElem=[Int0,Int1,Int2]';
else
    sourceLocalElem=[Int0,Int1]';
end
end

