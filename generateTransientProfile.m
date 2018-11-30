function [x,y,z] = generateTransientProfile(Problem)
%GENERATETRANSIENTPROFILE Summary of this function goes here
%   Detailed explanation goes here
y=Problem.mesh.nvec;
x=linspace(0,Problem.Transient.Time,(Problem.Transient.Time/Problem.Transient.dt)+1);
z=Problem.Solution;
end

