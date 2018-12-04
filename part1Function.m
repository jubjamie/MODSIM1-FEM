function [P] = part1Function(Theta,dt,BT,elements)
%PART1FUNCTION Easy function form of part 1
%   Good for looping through.
%   Demonstrates how the newTransientProblem class allows building and 
%   solving in a really concise and clear way.
P=newTransientProblem();
P.Mesh(0,1,elements);
P.Diffusion.coef=1;
P.Transient.dt=dt;
P.Transient.Theta=Theta;
P.BCS.D=[[0,0];[1,1];];
P.basisType=BT;
P.Solve(false);
end

