function [gamma] = calculateBurn(Problem)
%CALCULATEBURN Summary of this function goes here
%   Detailed explanation goes here
skin=Skin();
%This method is designed to find the first time step in an efficient way
% Firstly it linearly interpolates the data to find x at all times.
% Then uses optimised logical find() to get first time step with burn.
%Find approx burn point time index.
fieldAtX=EvaluateTransient(Problem,skin.E.xend);
burnTimeIndex=find(fieldAtX > 317.15,1);


burnSeries=fieldAtX(burnTimeIndex:end);

burnEq=2e98.*(exp((-12017)./(burnSeries-273.15)));

gamma=trapz(Problem.Transient.dt,burnEq);

end

