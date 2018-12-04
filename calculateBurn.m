function [gamma] = calculateBurn(Problem)
%CALCULATEBURN Calcualte gamma from Arrhenius rate equation

% Load in skin model
skin=Skin();

%This method is designed to find the first time step in an efficient way
% Firstly it linearly interpolates the data to find x at all times.
% Then uses optimised logical find() to get first time step with burn.

%Find approx burn point time index.
fieldAtX=EvaluateTransient(Problem,skin.E.xend);
burnTimeIndex=find(fieldAtX > 317.15,1);

if ~isempty(burnTimeIndex) % Checks to see if burnt at all
    
    % Timesteps only when Dermis is buurning
    burnSeries=fieldAtX(burnTimeIndex:end);
    
    % Arrhenius rate equation 
    burnEq=2e98.*(exp((-12017)./(burnSeries-273.15)));
    
    % Integrate to find solution
    gamma=trapz(burnEq)*Problem.Transient.dt;
else
    % If no burning occurs then return 0
    gamma=0;
end

end

