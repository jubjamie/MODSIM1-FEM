function [localElemMatrix] = LaplaceElemMatrix(D,eID,msh,varargin)
%LAPLACEELEMMATRIX Creates the diffusion localElem Matrix.
%   (D, eID, mesh)
%   D - The diffusion coefficents to use in the matrix.
%   eID - The ID of the element to create the local element matrix for.
%   msh - The mesh object for the problem.
%   varargin - Optional, prebuilt GQ scheme object

%Convert element boundary x values info to convinienet variable names.

x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);

% Logic to check for various diffusion coefs
% Coefs should come in as array of pairs.[x,D] e.g. [[0,1],[0.5,2]]
% If a single coef is input, just use that.
% The coef at the end will be used for the rest of the mesh
Dsize=size(D,1);
if Dsize > 1
    D(Dsize+1,:)=[msh.xmax,D(Dsize,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:Dsize+1
        % Find region that element is in and use corresponding coef
        if localx<abs(D(i+1,1)) && localx>=abs(D(i,1))
            D=D(i,2);
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
    % Quadratic Gradients
    dpsi0_dz=@(x) x-0.5;
    dpsi1_dz=@(x) -2.*x;
    dpsi2_dz=@(x) 0.5+x;
else
    %Linear Gradients
    dpsi0_dz=@(x) -0.5;
    dpsi1_dz=@(x) 0.5;
end
%zx Gradients
dz_dx=2/(x1-x0);

% Ints
Int00_gq=D.*dpsi0_dz(gq.xipts).*dz_dx.*dpsi0_dz(gq.xipts);
Int01_gq=D.*dpsi0_dz(gq.xipts).*dz_dx.*dpsi1_dz(gq.xipts);
if strcmp(msh.basisType,'Quad')
Int11_gq=D.*dpsi1_dz(gq.xipts).*dz_dx.*dpsi1_dz(gq.xipts);
Int02_gq=D.*dpsi0_dz(gq.xipts).*dz_dx.*dpsi2_dz(gq.xipts);
Int12_gq=D.*dpsi1_dz(gq.xipts).*dz_dx.*dpsi2_dz(gq.xipts);
Int22_gq=D.*dpsi2_dz(gq.xipts).*dz_dx.*dpsi2_dz(gq.xipts);
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

