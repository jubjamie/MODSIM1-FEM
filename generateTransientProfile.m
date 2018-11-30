function [x,y,z] = generateTransientProfile(Problem,timeRange)
%GENERATETRANSIENTPROFILE Summary of this function goes here
%   Detailed explanation goes here
if timeRange=='all'
y=Problem.mesh.nvec;
x=linspace(0,Problem.Transient.Time,(Problem.Transient.Time/Problem.Transient.dt)+1);
z=Problem.Solution;
else
y=Problem.mesh.nvec;
x=linspace(0,timeRange,(timeRange/Problem.Transient.dt)+1);
z=Problem.Solution(:,1:(timeRange/Problem.Transient.dt)+1);    
end

