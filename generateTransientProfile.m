function [x,y,z] = generateTransientProfile(Problem,timeRange)
%GENERATETRANSIENTPROFILE Summary of this function goes here
%   Detailed explanation goes here
if strcmp(timeRange,'all')
y=Problem.mesh.nvec;
x=linspace(0,Problem.Transient.Time,(Problem.Transient.Time/Problem.Transient.dt)+1);
if strcmp(Problem.basisType,'Quad')
z=Problem.Solution(1:2:end,:);
else
z=Problem.Solution;    
end
else
y=Problem.mesh.nvec;
x=linspace(0,timeRange,(timeRange/Problem.Transient.dt)+1);
if strcmp(Problem.basisType,'Quad')
z=Problem.Solution(1:2:end,1:(timeRange/Problem.Transient.dt)+1);
else
z=Problem.Solution(:,1:(timeRange/Problem.Transient.dt)+1);     
end
end

