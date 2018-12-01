function [Problem] = cw1_part2b(Q,TL,NumOfElems)
%PART2B Problem Template for part2b used for batching.
%   Takes in Q,TL as parameters for the problem with NumOfElems elements.
%
%   Outputs
%   Problem - A problem object structure set up for solving.

%Init empty problem.
Problem=newProblem;
% Give title based on inputs.
Problem.title=['Q=' num2str(Q) ', $T_L$=' num2str(TL)]; 
%Define mesh
Problem.mesh=OneDimLinearMeshGen(0,0.01,NumOfElems);
%Define Local element Generator functions
Problem.Diffusion.Generator=@LaplaceElemMatrix;
Problem.Reaction.Generator=@ReactionElemMatrix;

k=1.01e-5; %Given material constant.

%Set coefficients
Problem.Diffusion.coef=k;
Problem.Reaction.coef=-Q;

%Set up source term.
Problem.f.coef=Q*TL; % Constant multiplier.
Problem.f.fcn=sourceVector('1+(4*x)'); % Polynomial function in x.

%Set BCs
Problem.BCS.D=[[323.15,0];[293.15,0.01];];
end

