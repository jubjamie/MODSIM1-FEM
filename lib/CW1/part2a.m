function [Problem] = part2a(Q,TL,NumOfElems)
%PART2A The Problem template for the example in part 2a.
%   Given a value of Q, TL & number of elements,
%   a Problem object is returned with those parameters.

Problem=newProblem; %Init empty problem.

% Set a title for use in plotting function.
Problem.title=['Q=' num2str(Q) ', $T_L$=' num2str(TL)]; 

% Define mesh with input number of elements.
Problem.mesh=OneDimLinearMeshGen(0,0.01,NumOfElems); 

k=1.01e-5; % Define material constant diffusion coefficient.
Problem.Diffusion.coef=k; % Set diffusion coefficient.
Problem.Reaction.coef=-Q; % Set reaction coefficient.
Problem.f.coef=Q*TL; % Set constant source term.

%Set BCs T@x format.
Problem.BCS.D=[[323.15,0];[293.15,0.01];];

end