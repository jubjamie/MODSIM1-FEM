function [RMS] = L2Norm(Problem,aFcn,Time)
%L2NORM Summary of this function goes here
%   Detailed explanation goes here
% aFcn is should be a function handle with form (x,t) retruning
% a singular value from the analytical solution.

%Calculate the time index of Time.


% Make a GQ
N=3;
gq=makeGQ(N);

% Set up basis functions
basis0=@(z) (1-z)./2;
basis1=@(z) (1+z)./2;

% Loop through each element
Ne=Problem.mesh.ne;
elementInts=zeros(1,Ne);

for i=1:Ne
    diff_sq=zeros(1,N);
    for k=1:N
        % Get the numerical solution at surrounding nodes.
        c0=Problem.Solution(i,int16((Time/Problem.Transient.dt)+1));
        c1=Problem.Solution(i+1,int16((Time/Problem.Transient.dt)+1));
        Cxi=(c0*basis0(gq.xipts(k))+c1*basis1(gq.xipts(k)));
        
        %Get the analytical solution.
        %Calculate x at this gp.
        x0=Problem.mesh.elem(i).x(1);
        x1=Problem.mesh.elem(i).x(2);
        gp_x=(x0*basis0(gq.xipts(k))+x1*basis1(gq.xipts(k)));
        CE=aFcn(gp_x,Time);
        diff_sq(k)=(CE-Cxi)^2;
    end
    elementInts(i)=sum(Problem.mesh.elem(i).J.*gq.gsw.*diff_sq);
end

RMS=sqrt(sum(elementInts));