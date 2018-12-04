function [x,y,z] = generateTransientProfile(Problem,timeRange)
%GENERATETRANSIENTPROFILE Creates x,y,z of solution for time range.
% x=time
% y=x-domain position
% z=solution
% To be used with contors

% If all time ranges requested, show full range.
% Not useful when problem reaches steady state early on.
if strcmp(timeRange,'all')
    y=Problem.mesh.nvec;
    x=linspace(0,Problem.Transient.Time,(Problem.Transient.Time/Problem.Transient.dt)+1);
    if strcmp(Problem.basisType,'Quad')
        z=Problem.Solution(1:2:end,:);
    else
        z=Problem.Solution;
    end
else
    % Only create x,y,z profile up to timeRange value in time.
    y=Problem.mesh.nvec;
    x=linspace(0,timeRange,(timeRange/Problem.Transient.dt)+1);
    if strcmp(Problem.basisType,'Quad')
        z=Problem.Solution(1:2:end,1:(timeRange/Problem.Transient.dt)+1);
    else
        z=Problem.Solution(:,1:(timeRange/Problem.Transient.dt)+1);
    end
end

