function [Problem] = part1dProblem(NumOfElems)
%PART1DPROBLEM The Problem template for the example in part 1d.
%   Given a number of elements, a Problem object is returned with the requested mesh.
Problem=[]; % Init a new Problem Object
Problem.title=[num2str(NumOfElems) ' Elements']; % Set a title for this problem for plotting later.
Problem.mesh=OneDimLinearMeshGen(0,1,NumOfElems); % Set mesh x=0<>1 with input number of elements.

Problem.Diffusion.LE.Generator=@LaplaceElemMatrix; % Set the local element matrix generators for
Problem.Reaction.LE.Generator=@ReactionElemMatrix; % Diffusion and Reaction terms (Optional. Shown
                                                   % here as example of software flexibility.)
                                                   
Problem.Diffusion.LE.coef=1; % Set the diffusion coefficient.
Problem.Reaction.LE.coef=-9; % Set the reaction coefficient.
Problem.f.coef=0; % Set the source vector constant coefficient (Optional. Shown here as example).
Problem.BCS.D=[[0,0];[1,1];]; % Set 2 Dirichlet boundary conditions.
end

