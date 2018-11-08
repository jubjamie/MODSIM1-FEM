function [localElemMatrix] = ReactionElemMatrix(lambda,eID,msh)
%LAPLACEELEMMATRIX Creates the reaction local element matrix.
%   (lambda, eID, mesh)
%   lambda - The reaction coefficent to use in the matrix.
%   eID - The ID of the element to create the local element matrix for.
%   msh - The mesh object for the problem.
% Local element properties within mesh can accessed as follows:
%   Pos-x0: msh.elem(eID).x(1);   GlobalNodeID-x0: msh.elem(eID).n(1);
%   Pos-x1: msh.elem(eID).x(2);   GlobalNodeID-x1: msh.elem(eID).n(2);
%   Element Jacobian: msh.elem(eID).J;

%Convert mesh info to convinienet variable names.
J=msh.elem(eID).J;

Int00=(2/3)*lambda*J; % Calculate element values as in report derivation.
Int01=(1/3)*lambda*J;

localElemMatrix=[Int00, Int01;Int01, Int00]; % Assemble into 2x2 matrix.


end

