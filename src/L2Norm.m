function [RMS] = L2Norm(Problem,aFcn,Time)
%L2NORM Use GQ to calculate L2 Norm

% aFcn is should be a function handle with form (x,t) retruning
% a singular value from the analytical solution.

% Make a GQ
N=3;
gq=makeGQ(N);

% Define basis functions as anonymous functions
if strcmp(Problem.basisType,'Quad')
    %Using quad basis function so c=c0basis0+c1basis1+c2basis2
    basis0=@(z) (z*(z-1))./2;
    basis1=@(z) 1-z.^2;
    basis2=@(z) (z*(1+z))./2;
    xindexFcn=@(x) (2*x)-1; % Define common handle to get x index.
else
    basis0=@(z) (1-z)./2;
    basis1=@(z) (1+z)./2;
    xindexFcn=@(x) x; % Define common handle to get x index.
end

%For analytical always provide linear functions
Abasis0=@(z) (1-z)./2;
Abasis1=@(z) (1+z)./2;

% Loop through each element
Ne=Problem.mesh.ne;
elementInts=zeros(1,Ne);

for i=1:Ne
    diff_sq=zeros(1,N);
    for k=1:N
        % Get the numerical solution at surrounding nodes using basis functions
        solIndex=xindexFcn(i);
        c0=Problem.Solution(solIndex,int16((Time/Problem.Transient.dt)+1));
        c1=Problem.Solution(solIndex+1,int16((Time/Problem.Transient.dt)+1));
        if strcmp(Problem.basisType,'Quad')
            c2=Problem.Solution(solIndex+2,int16((Time/Problem.Transient.dt)+1));
            Cxi=(c0*basis0(gq.xipts(k))+c1*basis1(gq.xipts(k))+...
                c2*basis2(gq.xipts(k)));
        else
            Cxi=(c0*basis0(gq.xipts(k))+c1*basis1(gq.xipts(k)));
        end
        
        %Get the analytical solution.
        %Calculate x at this gp. Always use linear here as just spatial interp.
        x0=Problem.mesh.elem(i).x(1);
        x1=Problem.mesh.elem(i).x(2);
        gp_x=(x0*Abasis0(gq.xipts(k))+x1*Abasis1(gq.xipts(k)));
        CE=aFcn(gp_x,Time); % Analytical solution
        diff_sq(k)=(CE-Cxi)^2; % Difference squared
    end
    % Multiply by J and Gauss weights then sum
    elementInts(i)=sum(Problem.mesh.elem(i).J.*gq.gsw.*diff_sq);
end

RMS=sqrt(sum(elementInts)); % Sum errors over whole domain
end