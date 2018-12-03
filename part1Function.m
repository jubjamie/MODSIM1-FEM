function [P] = part1Function(Theta,dt,BT,elements)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
P=newTransientProblem();
P.Mesh(0,1,elements);
P.Diffusion.coef=1;
P.Transient.dt=dt;
P.Transient.Theta=Theta;
P.BCS.D=[[0,0];[1,1];];
P.basisType=BT;
P.Solve(false);
end

