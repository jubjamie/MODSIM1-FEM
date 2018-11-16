function [M,c,f,BCrhs,Problem] = globalMatrix(Problem)
%GLOBALMATRIX Calculates all requierd matrices and vectors to solve a 1D FEM problem.
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

% Sets defaults for when certain parameters are not set.
% If no local elem diffusion generator function is defined then set the
% default from Part 1a.
if(~isfield(Problem,'Diffusion') || ~isfield(Problem.Diffusion,'LE') ||...
        ~isfield(Problem.Diffusion.LE,'Generator'))
    Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
end

% If no Diffusion coefficient then set to zero and create empty anonymous function.
if(~isprop(Problem,'Diffusion') || ~isfield(Problem.Diffusion,'LE') ||...
        ~isfield(Problem.Diffusion.LE,'coef'))
    Problem.Diffusion.LE.Generator=@(a,b,c) 0; % Set the local elem function
    % to empty anon fcuntion.
    Problem.Diffusion.LE.coef=0;
end

% If no local elem reaction generator function is defined then set the default
% from Part 1b.
if(~isprop(Problem,'Reaction') || ~isfield(Problem.Reaction,'LE') ||...
        ~isfield(Problem.Reaction.LE,'Generator'))
    Problem.Reaction.LE.Generator=@ReactionElemMatrix;
end

% If no Reaction coefficient then set to zero and create empty anonymous function.
if(~isprop(Problem,'Reaction') || ~isfield(Problem.Reaction,'LE') ||...
        ~isfield(Problem.Reaction.LE,'coef'))
    Problem.Reaction.LE.Generator=@(a,b,c) 0;
    Problem.Reaction.LE.coef=0;
end

% If no source function is defined but a constant is, set to 1 to bypass.
% (Allows constant cource terms still).
if(~isprop(Problem,'f') || ~isfield(Problem.f,'fcn'))
    if (isprop(Problem,'f') && isfield(Problem.f,'coef'))
        Problem.f.fcn=@(a,b) 1;
    else
        Problem.f.fcn=@(a,b) 0; % With no function or constant term, set to
        % zero for no source terms at all.
    end
end

% If no constant multiplier is defined for polynomial source function then set to 1.
if(~isprop(Problem,'f') || ~isfield(Problem.f,'coef'))
    Problem.f.coef=1;
end

%------------%
% Generate Basic Global and Source

for i=1:N-1 % Loop through each element, creating its entry into the global
    % matrix/source vector.
    % Add the previous value to the new ones. (Allows local elem overlap)
    M(i:i+1,i:i+1)=M(i:i+1,i:i+1)+... 
        Problem.Diffusion.LE.Generator(Problem.Diffusion.LE.coef,i,Problem.mesh)-...
        Problem.Reaction.LE.Generator(Problem.Reaction.LE.coef,i,Problem.mesh);
    %^^ Insert local element matrices for diffusion and reaction as specified
    %^^ by the generator function.
    %^^ By using function handles referring to a local element function,
    %^^ this code can be extended to
    %^^ other problems with other function for generating local element matrices easily.
    
    % Calculate the source vector integrals symbolically.
    x0=Problem.mesh.elem(i).x(1); % Fetch x0 and x1 values for this element.
    x1=Problem.mesh.elem(i).x(2);
    
    % Populate the source vector by multiplying constant terms by a polynomial
    % function of x0,1 and the Jacobian.
    f(i:i+1,1)=f(i:i+1,1)+(Problem.f.coef*Problem.f.fcn(x0,x1)*Problem.mesh.elem(i).J);
    %^^ By using this function handle system, the appropiate source vector 
    %^^ generator can be compiled at runtime to the specified polynomial without the
    %^^ user having to integrate the variable source term.
end

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
        equivRow=((BCn(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1; 
        % Apply Neumann boundary at node in BC vector.
        BCrhs(equivRow)=BCn(1)*((2*BCn(2))-1); 
    end
end

%-------------%
% Enforce Dirichlet BCs
% Check if any Dirichlet BCs are specified and are of the correct size. 
% (i.e. [c, x-position].
if(isprop(Problem,'BCS') && isfield(Problem.BCS,'D') &&...
        size(Problem.BCS.D,1)>0 && size(Problem.BCS.D,2)==2)
    for j=1:size(Problem.BCS.D,1) % Loop through the Dirichlet BCs.
        BCd=Problem.BCS.D(j,:); % Select the BC for this loop.
        
        % Corresponding BC Vector node.
        equivRow=((BCd(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1; 
        % Assert that the x-position represents a node/row number in 
        % the global matrix
        assert(~mod(equivRow,1),'D.Boundary condition not specified for a node');
        
        % Apply the Dirichlet BC mathod to this BC.
        M(equivRow,:)=0; % Set global matrix row to zero.
        f(equivRow)=BCd(1); % Set source term/RHS to BC value.
        M(equivRow,equivRow)=1; % Set the diagonal element of the node to 1.
    end
end


% Clean up and place into Problem Object.
Problem.M=M; % Place global matrix into Problem.
Problem.c=c; % Place initialised results vector into Problem.
f=f+BCrhs;   % Sum source vector and Neumann BCs vector.
Problem.f.vec=f; % Place source vector into Problem.
Problem.BCrhs=BCrhs; % Place Neumann BCs vector into Problem for future reference.

end

