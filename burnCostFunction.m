function [cost] = burnCostFunction(temp,Problem)
%BURNCOSTFUNCTION Summary of this function goes here
%   Detailed explanation goes here
disp(temp);
Problem.BCS.D=[[temp,0];[310.15,0.01];];
Problem.Solve(false);
gamma=calculateBurn(Problem)
cost=abs(gamma-1);
end

