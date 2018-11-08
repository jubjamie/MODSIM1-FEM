function [localElemMatrix] = LaplaceElemMatrix(D,eID,msh)
%LAPLACEELEMMATRIX Creates the diffusion localElem Matrix.
%   (D, eID, mesh)
%   D - The diffusion coefficent to use in the matrix.
%   eID - The ID of the element to create the local element matrix for.
%   msh - The mesh object for the problem.
% Local element properties within mesh can accessed as follows:
%   Pos-x0: msh.elem(eID).x(1);   GlobalNodeID-x0: msh.elem(eID).n(1);
%   Pos-x1: msh.elem(eID).x(2);   GlobalNodeID-x1: msh.elem(eID).n(2);
%   Element Jacobian: msh.elem(eID).J;

%Convert element boundary x values info to convinienet variable names.
x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);

Int00=D/(x1-x0);    % Short forms as derived in report derivation.
Int01=-D/(x1-x0);

localElemMatrix=[Int00, Int01;Int01, Int00]; % Assemble into 2x2 matrix.


end

