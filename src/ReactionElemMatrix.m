function [localElemMatrix] = ReactionElemMatrix(lambda,eID,msh,varargin)
%LAPLACEELEMMATRIX Creates the reaction local element matrix.
%   (lambda, eID, mesh)
%   lambda - The reaction coefficent to use in the matrix.
%   eID - The ID of the element to create the local element matrix for.
%   msh - The mesh object for the problem.
%   varargin - Optional, prebuilt GQ scheme object

%Convert mesh info to convinienet variable names.
J=msh.elem(eID).J;
x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);

%Logic to check for various reaction coefs
% Coefs should come in as array of pairs.[x,lambda] e.g. [[0,1],[0.5,2]]
% If a single coef is input, just use that.
% The coef at the end will be used for the rest of the mesh
lambdasize=size(lambda,1);
if lambdasize > 1
    lambda(lambdasize+1)=[msh.xmax,lambda(end,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:lambdasize+1
        % Find region that element is in and use corresponding coef
        if localx<abs(lambda(i+1,1)) && localx>=abs(lambda(i,1))
            lambda=lambda(i,2);
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

% Linear gradients for now.

% Set basis functions as required
if strcmp(msh.basisType,'Quad')
    psi0=@(z) (z.*(z-1))./2;
    psi1=@(z) 1-z.^2;
    psi2=@(z) (z.*(1+z))./2;
else
    psi0=@(z) (1-z)./2;
    psi1=@(z) (1+z)./2;
end

% Calculate integrals.
Int00_gq=lambda.*psi0(gq.xipts).*psi0(gq.xipts).*J;
Int01_gq=lambda.*psi0(gq.xipts).*psi1(gq.xipts).*J;
if strcmp(msh.basisType,'Quad')
Int11_gq=lambda.*psi1(gq.xipts).*psi1(gq.xipts).*J;
Int02_gq=lambda.*psi0(gq.xipts).*psi2(gq.xipts).*J;
Int12_gq=lambda.*psi1(gq.xipts).*psi2(gq.xipts).*J;
Int22_gq=lambda.*psi2(gq.xipts).*psi2(gq.xipts).*J;
end

% Multiply by gauss weights and sum
Int00=sum(Int00_gq.*gq.gsw);
Int01=sum(Int01_gq.*gq.gsw);

%Arrange local element matrix as appropiate
if strcmp(msh.basisType,'Quad')
    
    Int11=sum(Int11_gq.*gq.gsw);
    Int02=sum(Int02_gq.*gq.gsw);
    Int12=sum(Int12_gq.*gq.gsw);
    Int22=sum(Int22_gq.*gq.gsw);
    
localElemMatrix=[Int00, Int01, Int02;
                 Int01, Int11, Int12;
                 Int02, Int12, Int22];
else
localElemMatrix=[Int00, Int01;
                 Int01, Int00];    

end
end