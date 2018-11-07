function [Problem] = part2a(Q,TL,NumOfElems)
%PART2A The Problem template for the example in part 2a.
%   Given a value of Q, TL & number of elements, a Problem object is returned with those parameters.

Problem=[]; %Init empty problem.
Problem.title=['Q=' num2str(Q) ', $T_L$=' num2str(TL)]; % Set a title for use in plotting function.
Problem.mesh=OneDimLinearMeshGen(0,0.01,NumOfElems); % Define mesh with input number of elements.

k=1.01e-5; % Define material constant diffusion coefficient.
Problem.Diffusion.LE.coef=k; % Set diffusion coefficient.
Problem.Reaction.LE.coef=-Q; % Set reaction coefficient.
Problem.f.fcn=sourceVector(Q*TL); % Create custom function that will generate local source vectors.
                                  % This allows polynomial source terms to be used later.
                                  % Accepts numeric constants too.

%Set BCs T@x format.
Problem.BCS.D=[[323.15,0];[293.15,0.01];];

end

