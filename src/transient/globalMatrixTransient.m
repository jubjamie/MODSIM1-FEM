function [M,c,f,BCrhs,Problem] = globalMatrixTransient(Problem)
%GLOBALMATRIXTRANSIENT Calculates all requierd matrices and vectors to solve a 1D FEM problem.
%Generates Global Matrix and source vector, then applies boundary conditions to the vectors.
%Also returns solution column vector initialised to zero
%   Problem - A valid Problem. Example of this formation includes part2b.m.
%           The Problem can contain the following:
%           Problem.title: A string title for the problem, useful for legends later.
%           Problem.mesh: The 1D mesh
%           Problem.Diffusion.LE.Generator: A function handle for a function
%                                           returning the local element matrix.
%                                           Optional, default will be set.
%           Problem.Diffusion.LE.coef: The diffusion coefficient D.
%           Problem.Reaction.LE.Generator: A function handle for a function
%                                          returning the local element matrix.
%           Problem.Reaction.LE.coef: The reaction coefficient lambda.
%                                     If not set, no reaction term used.
%           Problem.f.coef: A constant source term or constant multipying
%                           term for a polynomial source.
%           Problem.f.fcn: A function handle for a run-time integrated &
%                          compiled function for polynomial source terms.
%                          Definition example:
%                          Problem.f.fcn=sourceVector('1+(4*x)');
%                                       where x is the term for integration.
%
%           Problem.BCS.N: An array of Neumann boundary conditions using value@x notation.
%                          e.g.[[2,0];,[0,1];]; Sets gradient of 2 at x=0
%                                               and gradient of 0 at x=1.
%           Problem.BCS.D: An array of Dirichlet boundary conditions using value@x notation.
%                          e.g.[[2,0];,[0,1];]; Sets value of 2 at x=0
%                                               and value of 0 at x=1.
%   Outputs
%   M - Completed Global Matrix
%   c - Empty solution vector of correct size.
%   f - Completed Source Vector
%   BCrhs - The RHS BC vector that eventually gets added to f.
%   Updated Problem containing all above information added e.g. Problem.M = M

%-----------------%
% Init matrices
%Get problem info from mesh
N=Problem.mesh.ngn;  % Get matrix/vector size
c=zeros(N,1); % Pre-allocate solution vector
M=zeros(N); % Pre-allocate global matrix
f=zeros(N,1); % Pre-allocate source vector
BCrhs=zeros(N,1); % Pre-allocate a BC vector


% Generate Basic Global and Source


% Clean up and place into Problem Object.
Problem.M=M; % Place global matrix into Problem.
Problem.c=c; % Place initialised results vector into Problem.
f=f+BCrhs;   % Sum source vector and Neumann BCs vector.
Problem.f.vec=f; % Place source vector into Problem.
Problem.BCrhs=BCrhs; % Place Neumann BCs vector into Problem for future reference.

end

