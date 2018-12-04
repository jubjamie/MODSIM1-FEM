function [GM,GV,Problem] = globalMatrixTransientLinear(Problem)
%GLOBALMATRIXTRANSIENT Calculates all requierd matrices and vectors to solve a 1D FEM problem.
%Generates Global Matrix and source vector, then applies boundary conditions to the vectors.

%   Problem - A valid transient Problem as formed by newTransientProblem() Class

%   Outputs
%   GM - Completed Global Matrix
%   GV - Global Vector
%   Problem - Updated Problem object


%-----------------%
%NOTE THIS TRANSIENT VERSION USES M AS MASS MATRIX, NOT GLOBAL MATRIX
%LIKE THE STATIC VERSION

%Linear Version
%------------------%

% Init matrices
%Get problem info from mesh
N=Problem.mesh.ngn;  % Get matrix/vector size
c=zeros(N,1); % Pre-allocate solution vector
M=zeros(N); % Pre-allocate Mass Matrix
K=zeros(N); % Pre-allocate Stiffness Matrix
GM=zeros(N); % Pre-allocate Global Matrix
f=zeros(N,1); % Pre-allocate source vector
BCrhs=zeros(N,1); % Pre-allocate a BC vector

%Set global vector to contain previous source terms and BCs
GV=((1-Problem.Transient.Theta)*Problem.Transient.dt).*Problem.f.vec; % Pre-allocate Global Vector


% Generate Basic Global and Source

for i=1:N-1 % Loop through each element, creating its entry into the global
    % matrix/source vector.
    % For varying coefficients, a matrix of value<>x region is passed.
    % The local element matrices will use the appropiate value.
    
    % -- Mass Element  -- %
    % Same as reaction with lambda of 1.
    massElement=ReactionElemMatrix(1,i,Problem.mesh);
    % Add the previous value to the new ones. (Allows local elem overlap)
    M(i:i+1,i:i+1)=M(i:i+1,i:i+1)+massElement;

    % -- Stiffness Elements --%
    % Add the previous value to the new ones. (Allows local elem overlap)
    K(i:i+1,i:i+1)=K(i:i+1,i:i+1)+... 
        Problem.Diffusion.Generator(Problem.Diffusion.coef,i,Problem.mesh)-...
        (getReactionCoefs(Problem.Reaction.coef,i,Problem.mesh).*massElement);
    % Note that the reaction term is the mass elem*coefs to reduce function calls.
    
    % -- Source Terms -- %   
    f(i:i+1,1)=f(i:i+1,1)+...
        variableStaticSourceVector(Problem.f.coef,i,Problem.mesh);
end

% Assemble the global matrices/vectors according to the theta scheme.
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
        equivRow=((BCn(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1; 
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
        equivRow=((BCd(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1; 
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
