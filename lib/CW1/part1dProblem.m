function [Problem] = part1dProblem(NumOfElems)
%PART1DPROBLEM The Problem template for the example in part 1d.
%   Given a number of elements, a Problem object is returned with the requested mesh.
Problem=newProblem; % Init a new Problem Object

% Set a title for this problem for plotting later.
Problem.title=[num2str(NumOfElems) ' Elements']; 

% Set mesh x=0<>1 with input number of elements.
Problem.mesh=OneDimLinearMeshGen(0,1,NumOfElems); 

% Set the local element matrix generators for Diffusion and Reaction terms 
%(Optional. Shown here as example of software flexibility.)

Problem.Diffusion.Generator=@LaplaceElemMatrix; 
Problem.Reaction.Generator=@ReactionElemMatrix; 
                                                   
                                                   
Problem.Diffusion.coef=1; % Set the diffusion coefficient.
Problem.Reaction.coef=-9; % Set the reaction coefficient.

% Set the source vector constant coefficient (Optional. Shown here as example).
Problem.f.coef=0; 
Problem.BCS.D=[[0,0];[1,1];]; % Set 2 Dirichlet boundary conditions.
end

