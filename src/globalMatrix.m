function [M,c,f,BCrhs,Problem] = globalMatrix(Problem)
%GLOBALMATRIX Calculates all requierd matricies and vectors to solve a 1D FEM problem.
%Generates Global Matrix and source vector, then applies boundary conditions to the vectors.
%Also returns solution column vector initialised to zero
%   Problem - A valid Problem.
%
%   Outputs
%   M - Completed Global Matrix
%   c - Empty solution vector of correct size.
%   f - Completed Source Vector
%   BCrhs - The RHS BC vector that eventually gets added to f.
%   Updated Problem containing all above information added e.g. Problem.M = M

%% Init matricies
%Get problem info from mesh
N=Problem.mesh.ngn;
c=zeros(N,1);
M=zeros(N);
f=zeros(N,1);
BCrhs=zeros(N,1);

%If no Reaction or Diffusion coef or function set then set to zero and ignore.
if(~isfield(Problem,'Diffusion') || ~isfield(Problem.Diffusion,'LE') || ~isfield(Problem.Diffusion.LE,'coef')) % If no coeff then assume section not need and set all to zero.
Problem.Diffusion.LE.Generator=@(a,b,c) 0;
Problem.Diffusion.LE.coef=0;
end
if(~isfield(Problem,'Diffusion') || ~isfield(Problem.Diffusion,'LE') || ~isfield(Problem.Diffusion.LE,'Generator')) %If no generator specified, give default.
Problem.Diffusion.LE.Generator=@LaplaceElemMatrix;
end
if(~isfield(Problem,'Reaction') || ~isfield(Problem.Reaction,'LE') || ~isfield(Problem.Reaction.LE,'coef'))
Problem.Reaction.LE.Generator=@(a,b,c) 0;
Problem.Reaction.LE.coef=0;
end
if(~isfield(Problem,'Reaction') || ~isfield(Problem.Reaction,'LE') || ~isfield(Problem.Reaction.LE,'Generator'))
Problem.Reaction.LE.Generator=@ReactionElemMatrix;

end
if(~isfield(Problem,'f') || ~isfield(Problem.f,'fcn'))
    %If no function is defined then set to 0
Problem.f.fcn=@(a,b) 0;
end
if(~isfield(Problem,'f') || ~isfield(Problem.f,'coef'))
    %If no coef is defined then set to 1
Problem.f.coef=1;
end
%TODO Check only one BC set/node.

%% Generate Basic Global and Source
for i=1:N-1
%loop through each local elem matrix and place in row.
M(i:i+1,i:i+1)=M(i:i+1,i:i+1)+...
                Problem.Diffusion.LE.Generator(Problem.Diffusion.LE.coef,i,Problem.mesh)-...
                Problem.Reaction.LE.Generator(Problem.Reaction.LE.coef,i,Problem.mesh);
% Calculate the source vector integrals symbolically.
x0=Problem.mesh.elem(i).x(1);
x1=Problem.mesh.elem(i).x(2);

f(i:i+1,1)=f(i:i+1,1)+(Problem.f.coef*Problem.f.fcn(x0,x1)*Problem.mesh.elem(i).J);
end

%% Enforce Neumann Boundaries
if(isfield(Problem,'BCS') && isfield(Problem.BCS,'N') && size(Problem.BCS.N,1)>0 && size(Problem.BCS.N,2)==2)
    for j=1:size(Problem.BCS.N,1)
        BCn=Problem.BCS.N(j,:);
        %Calcualte equiv row for BC position x
        assert(isequal(BCn(2),Problem.mesh.xmin) || isequal(BCn(2),Problem.mesh.xmax),'N.Boundary condition not specified for an end node'); %Checks equivRow is of integer even if type is doulbe from above division.
        equivRow=((BCn(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1;
        BCrhs(equivRow)=BCn(1)*((2*BCn(2))-1);
    end
end

%% Enforce Dirichlet BCs
if(isfield(Problem,'BCS') && isfield(Problem.BCS,'D') && size(Problem.BCS.D,1)>0 && size(Problem.BCS.D,2)==2)
    for j=1:size(Problem.BCS.D,1)
        BCd=Problem.BCS.D(j,:);
        %Calcualte equiv row for BC position x
        equivRow=((BCd(2)/(Problem.mesh.xmax-Problem.mesh.xmin))*(N-1))+1;
        assert(~mod(equivRow,1),'D.Boundary condition not specified for a node'); %Checks equivRow is of integer even if type is doulbe from above division.
        M(equivRow,:)=0;
        f(equivRow)=BCd(1);
        M(equivRow,equivRow)=1;
    end
end


%% Clean up
Problem.M=M;
Problem.c=c;
f=f+BCrhs;
Problem.f=f;
Problem.BCrhs=BCrhs;

end

