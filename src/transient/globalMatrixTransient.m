function [GM,GV,Problem] = globalMatrixTransient(Problem)
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
%NOTE THIS TRANSIENT VERSION USES M AS MASS MATRIX, NOT GLOBAL MATRIX
%LIKE THE STATIC VERSION

% Init matrices
%Get problem info from mesh
N=Problem.mesh.ngn; %\/
Ne=Problem.mesh.ne; % \Get matrix/vector size
c=zeros((2*Ne)+1,1); % Pre-allocate solution vector
M=zeros((2*Ne)+1); % Pre-allocate Mass Matrix
K=zeros((2*Ne)+1); % Pre-allocate Stiffness Matrix
GM=zeros((2*Ne)+1); % Pre-allocate Global Matrix
f=zeros((2*Ne)+1,1); % Pre-allocate source vector
BCrhs=zeros((2*Ne)+1,1); % Pre-allocate a BC vector

%Set global vector to contain previous source terms and BCs
GV=((1-Problem.Transient.Theta)*Problem.Transient.dt).*Problem.f.vec; % Pre-allocate Global Vector


% Generate Basic Global and Source

for i=1:N-1 % Loop through each element, creating its entry into the global
    % matrix/source vector.
    % -- Mass Matrix (DIffusion) --
    % Add the previous value to the new ones. (Allows local elem overlap)
    massElement=ReactionElemMatrix(1,i,Problem.mesh);

    M((2*i)-1:(2*i)+1,(2*i)-1:(2*i)+1)=M((2*i)-1:(2*i)+1)+massElement;

    K((2*i)-1:(2*i)+1,(2*i)-1:(2*i)+1)=K((2*i)-1:(2*i)+1,(2*i)-1:(2*i)+1)+... 
        Problem.Diffusion.Generator(Problem.Diffusion.coef,i,Problem.mesh)-...
        (getReactionCoefs(Problem.Reaction.coef,i,Problem.mesh).*massElement);
    
    % Populate the source vector by multiplying constant terms by a polynomial
    % function of x0,1 and the Jacobian.
    f((2*i)-1:(2*i)+1,1)=f((2*i)-1:(2*i)+1,1)+...
        variableStaticSourceVector(Problem.f.coef,i,Problem.mesh);
end

GM=M+((Problem.Transient.Theta*Problem.Transient.dt).*K);
prevSolMultiplier=M-((1-Problem.Transient.Theta)*Problem.Transient.dt).*K;
GV=GV+prevSolMultiplier*Problem.c;
%-----------%
% Enforce Neumann Boundaries
% Check if any Neumann BCs are specified and are of the correct size.
% (i.e. [dc/dx, x-position].
if(isprop(Problem,'BCS') && isfield(Problem.BCS,'N') &&...
        size(Problem.BCS.N,1)>0 && size(Problem.BCS.N,2)==2)
    for j=1:size(Problem.BCS.N,1) % Loop through Neumann BCs.
        BCn=Problem.BCS.N(j,:); % Select the BC for this loop.
        % Assert that the x position of the BC must be at a boundary of the domain.
        assert(isequal(BCn(2),Problem.mesh.xmin) ||...
            isequal(BCn(2),Problem.mesh.xmax),...
            'N.Boundary condition not specified for an end node');
        
        % Corresponding BC Vector node.
        equivRow=2*((BCn(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1; 
        % Apply Neumann boundary at node in BC vector.
        BCrhs(equivRow)=BCn(1)*((2*BCn(2))-1); 
    end
end

% Calculate current step portion of GV
f=f+BCrhs;
GV=GV+((Problem.Transient.Theta*Problem.Transient.dt).*f);

%-------------%
% Enforce Dirichlet BCs
% Check if any Dirichlet BCs are specified and are of the correct size. 
% (i.e. [c, x-position].
if(isprop(Problem,'BCS') && isfield(Problem.BCS,'D') &&...
        size(Problem.BCS.D,1)>0 && size(Problem.BCS.D,2)==2)
    for j=1:size(Problem.BCS.D,1) % Loop through the Dirichlet BCs.
        BCd=Problem.BCS.D(j,:); % Select the BC for this loop.
        
        % Corresponding BC Vector node.
        equivRow=2*((BCd(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1; 
        % Assert that the x-position represents a node/row number in 
        % the global matrix
        assert(~mod(equivRow,1),'D.Boundary condition not specified for a node');
        
        % Apply the Dirichlet BC mathod to this BC.
        GM(equivRow,:)=0; % Set global matrix row to zero.
        GV(equivRow)=BCd(1); % Set source term/RHS to BC value.
        GM(equivRow,equivRow)=1; % Set the diagonal element of the node to 1.
    end
end


% Clean up and place into Problem Object.
Problem.GM=GM; % Place global matrix into Problem.
Problem.c=c; % Place initialised results vector into Problem.
Problem.f.vec=f; % Place source vector into Problem.
Problem.GV=GV;
Problem.BCrhs=BCrhs; % Place Neumann BCs vector into Problem for future reference.

end

